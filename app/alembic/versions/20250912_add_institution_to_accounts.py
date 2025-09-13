"""add institution to accounts

Revision ID: 20250912_add_institution
Revises: 20250912_add_goals
Create Date: 2025-09-12 00:15:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '20250912_add_institution'
down_revision: Union[str, None] = '20250912_add_goals'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('accounts', sa.Column('institution', sa.String(length=100), nullable=True))


def downgrade() -> None:
    op.drop_column('accounts', 'institution')

