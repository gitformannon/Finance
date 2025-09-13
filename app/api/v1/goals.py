from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import update
from uuid import UUID

from database import get_session
from models.goals import Goal
from models.users import User
import services.auth_service as auth_service
from schemas.goal import GoalRead, GoalCreate, GoalContribute, GoalUpdate


router = APIRouter(prefix="/goals", tags=["Goals"])


@router.get("", response_model=list[GoalRead])
async def list_goals(
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    result = await session.scalars(select(Goal).where(Goal.user_id == user.id).order_by(Goal.created_at.desc()))
    return list(result)


@router.post("", response_model=GoalRead, status_code=201)
async def create_goal(
    data: GoalCreate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    if data.target_amount < 0 or data.initial_amount < 0:
        raise HTTPException(status_code=422, detail="Amounts must be non-negative")
    if data.initial_amount > data.target_amount:
        raise HTTPException(status_code=422, detail="Initial amount cannot exceed target amount")

    goal = Goal(
        user_id=user.id,
        name=data.name,
        target_amount=int(data.target_amount),
        current_amount=int(data.initial_amount),
        target_date=data.target_date,
    )
    session.add(goal)
    await session.commit()
    await session.refresh(goal)
    return goal


@router.post("/{goal_id}/contribute", response_model=GoalRead)
async def contribute_to_goal(
    goal_id: UUID,
    payload: GoalContribute,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    if payload.amount == 0:
        raise HTTPException(status_code=422, detail="Amount must be non-zero")

    goal = await session.scalar(select(Goal).where(Goal.id == goal_id, Goal.user_id == user.id))
    if goal is None:
        raise HTTPException(status_code=404, detail="Goal not found")

    new_amount = int(goal.current_amount) + int(payload.amount)
    if new_amount < 0:
        new_amount = 0
    if new_amount > int(goal.target_amount):
        new_amount = int(goal.target_amount)

    goal.current_amount = new_amount
    await session.commit()
    await session.refresh(goal)
    return goal


@router.put("/{goal_id}", response_model=GoalRead)
async def update_goal(
    goal_id: UUID,
    data: GoalUpdate,
    user: User = Depends(auth_service.get_current_user_with_access),
    session: AsyncSession = Depends(get_session),
):
    goal = await session.scalar(select(Goal).where(Goal.id == goal_id, Goal.user_id == user.id))
    if goal is None:
        raise HTTPException(status_code=404, detail="Goal not found")
    if data.name is not None:
        goal.name = data.name
    if data.target_amount is not None:
        goal.target_amount = int(data.target_amount)
        if goal.current_amount > goal.target_amount:
            goal.current_amount = goal.target_amount
    if data.target_date is not None:
        goal.target_date = data.target_date
    await session.commit()
    await session.refresh(goal)
    return goal
