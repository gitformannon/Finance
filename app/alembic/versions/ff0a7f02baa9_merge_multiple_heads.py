"""Merge multiple heads

Revision ID: ff0a7f02baa9
Revises: 20240713_add_profile_fields, 7b8fb4fc8f5d
Create Date: 2025-07-19 15:19:37.249724

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'ff0a7f02baa9'
down_revision: Union[str, None] = ('20240713_add_profile_fields', '7b8fb4fc8f5d')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
