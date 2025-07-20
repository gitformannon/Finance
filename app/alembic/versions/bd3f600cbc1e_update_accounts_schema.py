"""update accounts schema to match models"""

from alembic import op
import sqlalchemy as sa

revision = 'bd3f600cbc1e'
down_revision = '20240720_add_categories'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # create enums
    account_type_enum = sa.Enum(
        'DEBIT_CARD',
        'CREDIT_CARD',
        'SAVINGS',
        'INVESTMENT',
        'CASH',
        'OTHER',
        name='accounttype'
    )
    account_status_enum = sa.Enum(
        'ACTIVE',
        'INACTIVE',
        'SUSPENDED',
        name='accountstatus'
    )
    account_type_enum.create(op.get_bind(), checkfirst=True)
    account_status_enum.create(op.get_bind(), checkfirst=True)

    # rename column "name" to "account_name"
    op.alter_column('accounts', 'name', new_column_name='account_name')

    # change column types
    op.alter_column('accounts', 'account_type',
                    existing_type=sa.String(length=20),
                    type_=account_type_enum,
                    existing_nullable=True)

    op.alter_column('accounts', 'status',
                    existing_type=sa.Integer(),
                    type_=account_status_enum,
                    server_default='ACTIVE',
                    existing_nullable=False)

    op.alter_column('accounts', 'balance',
                    existing_type=sa.Integer(),
                    server_default='0',
                    existing_nullable=False)

    op.alter_column('accounts', 'initial_balance',
                    existing_type=sa.Integer(),
                    server_default='0',
                    existing_nullable=False)

    # add new columns
    op.add_column('accounts', sa.Column('account_number', sa.String(length=20), nullable=True))
    op.add_column('accounts', sa.Column('color', sa.String(length=7), nullable=True))
    op.add_column('accounts', sa.Column('icon', sa.String(length=50), nullable=True))

    # create unique constraint for account_number
    op.create_unique_constraint('uq_account_account_number', 'accounts', ['account_number'])


def downgrade() -> None:
    op.drop_constraint('uq_account_account_number', 'accounts', type_='unique')
    op.drop_column('accounts', 'icon')
    op.drop_column('accounts', 'color')
    op.drop_column('accounts', 'account_number')

    op.alter_column('accounts', 'initial_balance',
                    existing_type=sa.Integer(),
                    server_default=None,
                    existing_nullable=False)

    op.alter_column('accounts', 'balance',
                    existing_type=sa.Integer(),
                    server_default=None,
                    existing_nullable=False)

    op.alter_column('accounts', 'status',
                    existing_type=sa.Enum('ACTIVE', 'INACTIVE', 'SUSPENDED', name='accountstatus'),
                    type_=sa.Integer(),
                    server_default=None,
                    existing_nullable=False)

    op.alter_column('accounts', 'account_type',
                    existing_type=sa.Enum('DEBIT_CARD', 'CREDIT_CARD', 'SAVINGS', 'INVESTMENT', 'CASH', 'OTHER', name='accounttype'),
                    type_=sa.String(length=20),
                    existing_nullable=True)

    op.alter_column('accounts', 'account_name', new_column_name='name')

    account_status_enum = sa.Enum('ACTIVE', 'INACTIVE', 'SUSPENDED', name='accountstatus')
    account_type_enum = sa.Enum('DEBIT_CARD', 'CREDIT_CARD', 'SAVINGS', 'INVESTMENT', 'CASH', 'OTHER', name='accounttype')
    account_status_enum.drop(op.get_bind(), checkfirst=True)
    account_type_enum.drop(op.get_bind(), checkfirst=True)
