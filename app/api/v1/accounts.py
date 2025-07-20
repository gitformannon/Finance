from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.accounts import Account, AccountType
from models.users import User
import services.auth_service as auth_service
from schemas.account import AccountRead, AccountCreate

router = APIRouter(prefix="/accounts", tags=["Accounts"])


@router.get("", response_model=list[AccountRead])
async def list_accounts(
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    result = await session.scalars(select(Account).where(Account.user_id == user.id))
    return list(result)


@router.post("", response_model=AccountRead, status_code=201)
async def create_account(
    data: AccountCreate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    acc = Account(
        user_id=user.id,
        account_name=data.account_name,
        account_number=data.account_number,
        account_type=data.account_type,
        balance=data.initial_balance,
        initial_balance=data.initial_balance,
    )
    session.add(acc)
    await session.commit()
    await session.refresh(acc)
    return acc
