from datetime import datetime, date, timedelta
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.transactions import Transaction
from models.accounts import Account
from models.users import User
import services.auth_service as auth_service
from schemas.transaction import TransactionRead, TransactionCreate

router = APIRouter(prefix="/transactions", tags=["Transactions"])

@router.get("", response_model=list[TransactionRead])
async def transactions_by_date(
    date: date,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    start = datetime.combine(date, datetime.min.time())
    end = start + timedelta(days=1)
    stmt = select(Transaction).where(
        Transaction.user_id == user.id,
        Transaction.created_at >= start,
        Transaction.created_at < end,
    ).order_by(Transaction.created_at.desc())
    result = await session.scalars(stmt)
    return list(result)


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

