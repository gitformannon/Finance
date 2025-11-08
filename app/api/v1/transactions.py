from datetime import datetime, timedelta
import re
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.transactions import Transaction
from models.accounts import Account
from models.categories import Category
from models.accounts import Account
from models.users import User
import services.auth_service as auth_service
from schemas.transaction import TransactionRead, TransactionCreate, TransactionUpdate

router = APIRouter(prefix="/transactions", tags=["Transactions"])

def _parse_date_range(date_text: str) -> tuple[datetime, datetime]:
    """Return an inclusive [start, end) datetime range for the given date_text.

    Supported formats:
    - YYYY         -> whole year
    - YYYY-MM      -> whole month
    - YYYY-MM-DD   -> single day
    """
    # Year
    if re.fullmatch(r"\d{4}", date_text):
        y = int(date_text)
        start = datetime(y, 1, 1)
        end = datetime(y + 1, 1, 1)
        return start, end

    # Year-Month
    if re.fullmatch(r"\d{4}-\d{2}", date_text):
        y = int(date_text[0:4])
        m = int(date_text[5:7])
        if not 1 <= m <= 12:
            raise ValueError("Invalid month")
        start = datetime(y, m, 1)
        if m == 12:
            end = datetime(y + 1, 1, 1)
        else:
            end = datetime(y, m + 1, 1)
        return start, end

    # Year-Month-Day
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", date_text):
        y, m, d = map(int, date_text.split("-"))
        start = datetime(y, m, d)
        end = start + timedelta(days=1)
        return start, end

    raise ValueError("Unsupported date format")


@router.get("", response_model=list[TransactionRead])
async def transactions_by_date(
    date: str = Query(..., description="Date in 'YYYY', 'YYYY-MM', or 'YYYY-MM-DD'"),
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    try:
        start, end = _parse_date_range(date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use 'YYYY', 'YYYY-MM', or 'YYYY-MM-DD'.")
    stmt = (
        select(
            Transaction,
            Account.account_name.label("account_name"),
            Category.name.label("category_name"),
        )
        .join(Account, Account.id == Transaction.account_id)
        .join(Category, Category.id == Transaction.category_id, isouter=True)
        .where(
            Transaction.user_id == user.id,
            Transaction.created_at >= start,
            Transaction.created_at < end,
        )
        .order_by(Transaction.created_at.desc())
    )
    rows = await session.execute(stmt)
    items: list[TransactionRead] = []
    for tx, account_name, category_name in rows.all():
        as_dict = {
            "id": tx.id,
            "account_id": tx.account_id,
            "to_account": tx.to_account,
            "category_id": tx.category_id,
            "amount": tx.amount,
            "description": tx.description,
            "created_at": tx.created_at,
            "account_name": account_name,
            "category_name": category_name,
        }
        items.append(TransactionRead(**as_dict))
    return items


@router.post("", response_model=TransactionRead, status_code=201)
async def create_transaction(
    data: TransactionCreate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    # Normalize amount and derive deltas for accounts
    normalized_amount = int(data.amount)
    src_delta: int
    dst_delta: int | None = None

    if data.type == "transfer":
        # Transfers always debit source and credit destination by the absolute amount
        amt = abs(normalized_amount)
        src_delta = -amt
        dst_delta = amt
    else:
        # Income: positive, Purchase: negative
        if data.type == "purchase" and normalized_amount > 0:
            normalized_amount = -normalized_amount
        src_delta = normalized_amount

    to_account_value = data.to_account
    if to_account_value is None and data.to_account_id is not None:
        to_account_value = str(data.to_account_id)

    # Create transaction row
    tx = Transaction(
        user_id=user.id,
        account_id=data.account_id,
        category_id=data.category_id,
        to_account=to_account_value,
        amount=src_delta if data.type == "transfer" else normalized_amount,
        description=data.note,
        created_at=datetime.combine(data.date, datetime.min.time()),
    )
    session.add(tx)

    # Atomically update balances for involved accounts
    # Source account
    src_acc = await session.scalar(select(Account).where(Account.id == data.account_id, Account.user_id == user.id))
    if src_acc is not None:
        src_acc.balance = int(src_acc.balance) + src_delta

    # Destination account (for transfers)
    if data.type == "transfer" and data.to_account_id is not None:
        dst_acc = await session.scalar(select(Account).where(Account.id == data.to_account_id, Account.user_id == user.id))
        if dst_acc is not None and dst_delta is not None:
            dst_acc.balance = int(dst_acc.balance) + dst_delta

    await session.commit()
    await session.refresh(tx)
    return tx


@router.put("/{tx_id}", response_model=TransactionRead)
async def update_transaction(
    tx_id: str,
    data: TransactionUpdate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    tx = await session.scalar(select(Transaction).where(Transaction.id == tx_id, Transaction.user_id == user.id))
    if tx is None:
        raise HTTPException(status_code=404, detail="Transaction not found")
    if data.category_id is not None:
        tx.category_id = data.category_id
    if data.note is not None:
        tx.description = data.note
    await session.commit()
    await session.refresh(tx)
    return tx
