"""add TOTP fields to user"""

from alembic import op
import sqlalchemy as sa

revision = '1749362043'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    op.add_column('users', sa.Column('totp_secret', sa.LargeBinary(), nullable=True))
    op.add_column('users', sa.Column('is_totp_enabled', sa.Boolean(), nullable=False, server_default=sa.text('false')))


def downgrade():
    op.drop_column('users', 'is_totp_enabled')
    op.drop_column('users', 'totp_secret')
