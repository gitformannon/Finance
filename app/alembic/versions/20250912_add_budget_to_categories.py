"""add budget to categories

Revision ID: 20250912_add_budget_to_categories
Revises: 20250912_add_institution
Create Date: 2025-09-12 01:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '20250912_add_budget_to_categories'
down_revision: Union[str, None] = '20250912_add_institution'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('categories', sa.Column('budget', sa.BigInteger(), nullable=True))


def downgrade() -> None:
    op.drop_column('categories', 'budget')

