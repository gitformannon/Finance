"""add profile fields"""

from alembic import op
import sqlalchemy as sa

revision = '20240713_add_profile_fields'
down_revision = '1749362043'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column('users', sa.Column('first_name', sa.String(length=50), nullable=False, server_default='User'))
    op.add_column('users', sa.Column('last_name', sa.String(length=50), nullable=True))
    op.add_column('users', sa.Column('profile_image', sa.String(length=255), nullable=True))


def downgrade() -> None:
    op.drop_column('users', 'profile_image')
    op.drop_column('users', 'last_name')
    op.drop_column('users', 'first_name')
