"""merge institution + a0a0cc91318c

Revision ID: 147871ef11b1
Revises: 20250912_add_institution, a0a0cc91318c
Create Date: 2025-09-12 20:55:45.859200

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '147871ef11b1'
down_revision: Union[str, None] = ('20250912_add_institution', 'a0a0cc91318c')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
