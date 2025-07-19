"""add categories table"""

from alembic import op
import sqlalchemy as sa

revision = '20240720_add_categories'
down_revision = '20240713_add_profile_fields'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'categories',
        sa.Column('id', sa.UUID(), nullable=False),
        sa.Column('user_id', sa.UUID(), nullable=False),
        sa.Column('name', sa.String(length=50), nullable=False),
        sa.Column(
            'type',
            sa.Enum('INCOME', 'PURCHASE', name='categorytype'),
            nullable=False,
        ),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.Column(
            'updated_at',
            sa.DateTime(timezone=True),
            server_default=sa.text('now()'),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.add_column('transactions', sa.Column('category_id', sa.UUID(), nullable=True))
    op.create_foreign_key(None, 'transactions', 'categories', ['category_id'], ['id'], ondelete='SET NULL')


def downgrade() -> None:
    op.drop_constraint(None, 'transactions', type_='foreignkey')
    op.drop_column('transactions', 'category_id')
    op.drop_table('categories')
