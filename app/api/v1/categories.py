from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.categories import Category, CategoryType
from models.users import User
import services.auth_service as auth_service
from schemas.category import CategoryCreate, CategoryRead

router = APIRouter(prefix="/categories", tags=["Categories"])


@router.get("", response_model=list[CategoryRead])
async def list_categories(
    type: CategoryType | None = None,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    stmt = select(Category).where(Category.user_id == user.id)
    if type:
        stmt = stmt.where(Category.type == type)
    result = await session.scalars(stmt)
    return list(result)


@router.post("", response_model=CategoryRead, status_code=201)
async def create_category(
    data: CategoryCreate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    cat = Category(
        user_id=user.id,
        name=data.name,
        type=data.type,
    )
    session.add(cat)
    await session.commit()
    await session.refresh(cat)
    return cat
