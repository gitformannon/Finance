from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from models.accounts import Account
from models.transactions import Transaction


async def reconcile_account_balances(session: AsyncSession) -> None:
    """
    Recompute each account.balance from initial_balance plus all transactions since account creation.
    """
    accounts = await session.scalars(select(Account))
    for acc in accounts:
        txs = await session.scalars(
            select(Transaction).where(Transaction.account_id == acc.id)
        )
        total_delta = 0
        for tx in txs:
            total_delta += int(tx.amount)
        acc.balance = int(acc.initial_balance) + total_delta
    await session.commit()


