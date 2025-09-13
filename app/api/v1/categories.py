from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.categories import Category, CategoryType
from models.users import User
import services.auth_service as auth_service
from schemas.category import CategoryCreate, CategoryRead, CategoryUpdate

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
        budget=data.budget,
    )
    session.add(cat)
    await session.commit()
    await session.refresh(cat)
    return cat


@router.put("/{category_id}", response_model=CategoryRead)
async def update_category(
    category_id: str,
    data: CategoryUpdate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    cat = await session.scalar(select(Category).where(Category.id == category_id, Category.user_id == user.id))
    if cat is None:
        raise HTTPException(status_code=404, detail="Category not found")
    if data.name is not None:
        cat.name = data.name
    if data.type is not None:
        cat.type = data.type
    if data.budget is not None:
        cat.budget = data.budget
    await session.commit()
    await session.refresh(cat)
    return cat
