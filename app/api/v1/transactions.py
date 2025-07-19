from datetime import datetime, date, timedelta
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.transactions import Transaction
from models.users import User
import services.auth_service as auth_service
from schemas.transaction import TransactionRead, TransactionCreate

router = APIRouter(prefix="/transactions", tags=["Transactions"])

@router.get("", response_model=list[TransactionRead])
async def transactions_by_date(
    date: date,
    user: User = Depends(auth_service.get_current_user),
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
    user: User = Depends(auth_service.get_current_user),
    session: AsyncSession = Depends(get_session),
):
    amount = int(data.amount)
    if data.type == "purchase" and amount > 0:
        amount = -amount
    tx = Transaction(
        user_id=user.id,
        account_id=data.account_id,
        category_id=data.category_id,
        amount=amount,
        description=data.note,
        created_at=datetime.combine(data.date, datetime.min.time()),
    )
    session.add(tx)
    await session.commit()
    await session.refresh(tx)
    return tx

