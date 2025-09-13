"""Add categories

Revision ID: a0a0cc91318c
Revises: ff0a7f02baa9
Create Date: 2025-07-19 15:20:28.017633

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a0a0cc91318c'
down_revision: Union[str, None] = 'ff0a7f02baa9'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass

def downgrade() -> None:
    pass
