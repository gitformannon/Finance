"""add emoji_path to categories, accounts, and goals

Revision ID: 20251109_add_emoji_path
Revises: 20250912_add_budget_to_categories
Create Date: 2025-11-09 01:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '20251109_add_emoji_path'
down_revision: Union[str, None] = '20250912_add_budget_to_categories'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('categories', sa.Column('emoji_path', sa.String(length=255), nullable=True))
    op.add_column('accounts', sa.Column('emoji_path', sa.String(length=255), nullable=True))
    op.add_column('goals', sa.Column('emoji_path', sa.String(length=255), nullable=True))


def downgrade() -> None:
    op.drop_column('goals', 'emoji_path')
    op.drop_column('accounts', 'emoji_path')
    op.drop_column('categories', 'emoji_path')

