"""add to_account column

Revision ID: c2b2092bb0bd
Revises: be8b27f5b08c
Create Date: 2025-07-21 08:44:57.795718

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'c2b2092bb0bd'
down_revision: Union[str, None] = 'be8b27f5b08c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema by adding the ``to_account`` column."""
    op.add_column('transactions', sa.Column('to_account', sa.String(length=36), nullable=True))


def downgrade() -> None:
    """Downgrade schema by dropping the ``to_account`` column."""
    op.drop_column('transactions', 'to_account')

