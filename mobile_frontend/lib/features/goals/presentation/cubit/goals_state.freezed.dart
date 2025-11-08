// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goals_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GoalsState {
  List<Goal> get goals => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of GoalsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalsStateCopyWith<GoalsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalsStateCopyWith<$Res> {
  factory $GoalsStateCopyWith(
    GoalsState value,
    $Res Function(GoalsState) then,
  ) = _$GoalsStateCopyWithImpl<$Res, GoalsState>;
  @useResult
  $Res call({List<Goal> goals, bool loading, String? error});
}

/// @nodoc
class _$GoalsStateCopyWithImpl<$Res, $Val extends GoalsState>
    implements $GoalsStateCopyWith<$Res> {
  _$GoalsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goals = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            goals:
                null == goals
                    ? _value.goals
                    : goals // ignore: cast_nullable_to_non_nullable
                        as List<Goal>,
            loading:
                null == loading
                    ? _value.loading
                    : loading // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GoalsStateImplCopyWith<$Res>
    implements $GoalsStateCopyWith<$Res> {
  factory _$$GoalsStateImplCopyWith(
    _$GoalsStateImpl value,
    $Res Function(_$GoalsStateImpl) then,
  ) = __$$GoalsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Goal> goals, bool loading, String? error});
}

/// @nodoc
class __$$GoalsStateImplCopyWithImpl<$Res>
    extends _$GoalsStateCopyWithImpl<$Res, _$GoalsStateImpl>
    implements _$$GoalsStateImplCopyWith<$Res> {
  __$$GoalsStateImplCopyWithImpl(
    _$GoalsStateImpl _value,
    $Res Function(_$GoalsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoalsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goals = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$GoalsStateImpl(
        goals:
            null == goals
                ? _value._goals
                : goals // ignore: cast_nullable_to_non_nullable
                    as List<Goal>,
        loading:
            null == loading
                ? _value.loading
                : loading // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$GoalsStateImpl implements _GoalsState {
  const _$GoalsStateImpl({
    final List<Goal> goals = const [],
    this.loading = false,
    this.error,
  }) : _goals = goals;

  final List<Goal> _goals;
  @override
  @JsonKey()
  List<Goal> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;

  @override
  String toString() {
    return 'GoalsState(goals: $goals, loading: $loading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalsStateImpl &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_goals),
    loading,
    error,
  );

  /// Create a copy of GoalsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalsStateImplCopyWith<_$GoalsStateImpl> get copyWith =>
      __$$GoalsStateImplCopyWithImpl<_$GoalsStateImpl>(this, _$identity);
}

abstract class _GoalsState implements GoalsState {
  const factory _GoalsState({
    final List<Goal> goals,
    final bool loading,
    final String? error,
  }) = _$GoalsStateImpl;

  @override
  List<Goal> get goals;
  @override
  bool get loading;
  @override
  String? get error;

  /// Create a copy of GoalsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalsStateImplCopyWith<_$GoalsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
