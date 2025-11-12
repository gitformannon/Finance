// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_goal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AddGoalState {
  String get name => throw _privateConstructorUsedError;
  int get targetAmount => throw _privateConstructorUsedError;
  DateTime? get targetDate => throw _privateConstructorUsedError;
  String? get emoji_path => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AddGoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddGoalStateCopyWith<AddGoalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddGoalStateCopyWith<$Res> {
  factory $AddGoalStateCopyWith(
    AddGoalState value,
    $Res Function(AddGoalState) then,
  ) = _$AddGoalStateCopyWithImpl<$Res, AddGoalState>;
  @useResult
  $Res call({
    String name,
    int targetAmount,
    DateTime? targetDate,
    String? emoji_path,
    RequestStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class _$AddGoalStateCopyWithImpl<$Res, $Val extends AddGoalState>
    implements $AddGoalStateCopyWith<$Res> {
  _$AddGoalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddGoalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? targetAmount = null,
    Object? targetDate = freezed,
    Object? emoji_path = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            targetAmount:
                null == targetAmount
                    ? _value.targetAmount
                    : targetAmount // ignore: cast_nullable_to_non_nullable
                        as int,
            targetDate:
                freezed == targetDate
                    ? _value.targetDate
                    : targetDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            emoji_path:
                freezed == emoji_path
                    ? _value.emoji_path
                    : emoji_path // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as RequestStatus,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddGoalStateImplCopyWith<$Res>
    implements $AddGoalStateCopyWith<$Res> {
  factory _$$AddGoalStateImplCopyWith(
    _$AddGoalStateImpl value,
    $Res Function(_$AddGoalStateImpl) then,
  ) = __$$AddGoalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int targetAmount,
    DateTime? targetDate,
    String? emoji_path,
    RequestStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class __$$AddGoalStateImplCopyWithImpl<$Res>
    extends _$AddGoalStateCopyWithImpl<$Res, _$AddGoalStateImpl>
    implements _$$AddGoalStateImplCopyWith<$Res> {
  __$$AddGoalStateImplCopyWithImpl(
    _$AddGoalStateImpl _value,
    $Res Function(_$AddGoalStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddGoalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? targetAmount = null,
    Object? targetDate = freezed,
    Object? emoji_path = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AddGoalStateImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        targetAmount:
            null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                    as int,
        targetDate:
            freezed == targetDate
                ? _value.targetDate
                : targetDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        emoji_path:
            freezed == emoji_path
                ? _value.emoji_path
                : emoji_path // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as RequestStatus,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$AddGoalStateImpl implements _AddGoalState {
  const _$AddGoalStateImpl({
    this.name = '',
    this.targetAmount = 0,
    this.targetDate,
    this.emoji_path,
    this.status = RequestStatus.initial,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int targetAmount;
  @override
  final DateTime? targetDate;
  @override
  final String? emoji_path;
  @override
  @JsonKey()
  final RequestStatus status;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AddGoalState(name: $name, targetAmount: $targetAmount, targetDate: $targetDate, emoji_path: $emoji_path, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddGoalStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.emoji_path, emoji_path) ||
                other.emoji_path == emoji_path) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    targetAmount,
    targetDate,
    emoji_path,
    status,
    errorMessage,
  );

  /// Create a copy of AddGoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddGoalStateImplCopyWith<_$AddGoalStateImpl> get copyWith =>
      __$$AddGoalStateImplCopyWithImpl<_$AddGoalStateImpl>(this, _$identity);
}

abstract class _AddGoalState implements AddGoalState {
  const factory _AddGoalState({
    final String name,
    final int targetAmount,
    final DateTime? targetDate,
    final String? emoji_path,
    final RequestStatus status,
    final String? errorMessage,
  }) = _$AddGoalStateImpl;

  @override
  String get name;
  @override
  int get targetAmount;
  @override
  DateTime? get targetDate;
  @override
  String? get emoji_path;
  @override
  RequestStatus get status;
  @override
  String? get errorMessage;

  /// Create a copy of AddGoalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddGoalStateImplCopyWith<_$AddGoalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
