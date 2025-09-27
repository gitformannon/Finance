"""empty message

Revision ID: f23a8c523fc5
Revises: 147871ef11b1, 20250912_add_budget_to_categories
Create Date: 2025-09-14 14:52:48.509968

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f23a8c523fc5'
down_revision: Union[str, None] = ('147871ef11b1', '20250912_add_budget_to_categories')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
