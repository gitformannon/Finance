// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginUserRequest _$LoginUserRequestFromJson(Map<String, dynamic> json) {
  return _LoginUserRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginUserRequest {
  String? get phone => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  /// Serializes this LoginUserRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginUserRequestCopyWith<LoginUserRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginUserRequestCopyWith<$Res> {
  factory $LoginUserRequestCopyWith(
          LoginUserRequest value, $Res Function(LoginUserRequest) then) =
      _$LoginUserRequestCopyWithImpl<$Res, LoginUserRequest>;
  @useResult
  $Res call({String? phone, String? password});
}

/// @nodoc
class _$LoginUserRequestCopyWithImpl<$Res, $Val extends LoginUserRequest>
    implements $LoginUserRequestCopyWith<$Res> {
  _$LoginUserRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginUserRequestImplCopyWith<$Res>
    implements $LoginUserRequestCopyWith<$Res> {
  factory _$$LoginUserRequestImplCopyWith(_$LoginUserRequestImpl value,
          $Res Function(_$LoginUserRequestImpl) then) =
      __$$LoginUserRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? phone, String? password});
}

/// @nodoc
class __$$LoginUserRequestImplCopyWithImpl<$Res>
    extends _$LoginUserRequestCopyWithImpl<$Res, _$LoginUserRequestImpl>
    implements _$$LoginUserRequestImplCopyWith<$Res> {
  __$$LoginUserRequestImplCopyWithImpl(_$LoginUserRequestImpl _value,
      $Res Function(_$LoginUserRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = freezed,
    Object? password = freezed,
  }) {
    return _then(_$LoginUserRequestImpl(
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginUserRequestImpl implements _LoginUserRequest {
  const _$LoginUserRequestImpl({this.phone, this.password});

  factory _$LoginUserRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginUserRequestImplFromJson(json);

  @override
  final String? phone;
  @override
  final String? password;

  @override
  String toString() {
    return 'LoginUserRequest(phone: $phone, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phone, password);

  /// Create a copy of LoginUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserRequestImplCopyWith<_$LoginUserRequestImpl> get copyWith =>
      __$$LoginUserRequestImplCopyWithImpl<_$LoginUserRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginUserRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginUserRequest implements LoginUserRequest {
  const factory _LoginUserRequest(
      {final String? phone, final String? password}) = _$LoginUserRequestImpl;

  factory _LoginUserRequest.fromJson(Map<String, dynamic> json) =
      _$LoginUserRequestImpl.fromJson;

  @override
  String? get phone;
  @override
  String? get password;

  /// Create a copy of LoginUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginUserRequestImplCopyWith<_$LoginUserRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
