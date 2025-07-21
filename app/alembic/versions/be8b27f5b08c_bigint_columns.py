"""switch integer columns to bigint"""

from alembic import op
import sqlalchemy as sa

revision = 'be8b27f5b08c'
down_revision = 'int_enum_migration'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.alter_column(
        'accounts',
        'balance',
        existing_type=sa.Integer(),
        type_=sa.BigInteger(),
        postgresql_using='balance::bigint',
        server_default='0',
        existing_nullable=False,
    )
    op.alter_column(
        'accounts',
        'limit',
        existing_type=sa.Integer(),
        type_=sa.BigInteger(),
        postgresql_using='"limit"::bigint',
        existing_nullable=True,
    )
    op.alter_column(
        'transactions',
        'amount',
        existing_type=sa.Integer(),
        type_=sa.BigInteger(),
        postgresql_using='amount::bigint',
        existing_nullable=False,
    )


def downgrade() -> None:
    op.alter_column(
        'transactions',
        'amount',
        existing_type=sa.BigInteger(),
        type_=sa.Integer(),
        postgresql_using='amount::integer',
        existing_nullable=False,
    )
    op.alter_column(
        'accounts',
        'limit',
        existing_type=sa.BigInteger(),
        type_=sa.Integer(),
        postgresql_using='"limit"::integer',
        existing_nullable=True,
    )
    op.alter_column(
        'accounts',
        'balance',
        existing_type=sa.BigInteger(),
        type_=sa.Integer(),
        postgresql_using='balance::integer',
        server_default='0',
        existing_nullable=False,
    )

