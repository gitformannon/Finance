from sqlalchemy.types import TypeDecorator, Integer

class IntEnumType(TypeDecorator):
    """Store IntEnum values as integers in the database."""

    impl = Integer
    cache_ok = True

    def __init__(self, enum_cls, *args, **kwargs):
        self.enum_cls = enum_cls
        super().__init__(*args, **kwargs)

    def process_bind_param(self, value, dialect):
        if value is None:
            return None
        return int(value)

    def process_result_value(self, value, dialect):
        if value is None:
            return None
        return self.enum_cls(value)
