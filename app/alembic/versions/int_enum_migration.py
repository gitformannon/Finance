"""switch to int enums"""

from alembic import op
import sqlalchemy as sa

revision = 'int_enum_migration'
down_revision = 'bd3f600cbc1e'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.alter_column(
        'categories',
        'type',
        existing_type=sa.Enum('INCOME', 'PURCHASE', 'TRANSFER', name='categorytype'),
        type_=sa.Integer(),
        postgresql_using="CASE type WHEN 'INCOME' THEN 1 WHEN 'PURCHASE' THEN -1 ELSE NULL END",
        existing_nullable=False,
    )
    op.execute('DROP TYPE IF EXISTS categorytype')

    op.alter_column(
        'accounts',
        'account_type',
        existing_type=sa.Enum('DEBIT_CARD', 'CREDIT_CARD', 'SAVINGS', 'INVESTMENT', 'CASH', 'OTHER', name='account_type'),
        type_=sa.Integer(),
        postgresql_using=(
            "CASE account_type "
            "WHEN 'DEBIT_CARD' THEN 1 "
            "WHEN 'CREDIT_CARD' THEN 2 "
            "WHEN 'SAVINGS' THEN 3 "
            "WHEN 'INVESTMENT' THEN 4 "
            "WHEN 'CASH' THEN 5 "
            "WHEN 'OTHER' THEN 6 "
            "END"
        ),
        existing_nullable=True,
    )
    op.execute('DROP TYPE IF EXISTS account_type')

    # drop existing default so PostgreSQL doesn't try to cast it
    op.alter_column(
        'accounts',
        'status',
        server_default=None,
        existing_type=sa.Enum('ACTIVE', 'INACTIVE', 'SUSPENDED', name='account_status'),
        existing_nullable=False,
    )

    # convert enum values to integers
    op.alter_column(
        'accounts',
        'status',
        existing_type=sa.Enum('ACTIVE', 'INACTIVE', 'SUSPENDED', name='account_status'),
        type_=sa.Integer(),
        postgresql_using=(
            "CASE status "
            "WHEN 'ACTIVE' THEN 1 "
            "WHEN 'INACTIVE' THEN 0 "
            "WHEN 'SUSPENDED' THEN -1 "
            "END"
        ),
        existing_nullable=False,
    )

    # set new integer default
    op.alter_column(
        'accounts',
        'status',
        server_default='1',
        existing_type=sa.Integer(),
        existing_nullable=False,
    )

    op.execute('DROP TYPE IF EXISTS account_status')


def downgrade() -> None:
    pass
