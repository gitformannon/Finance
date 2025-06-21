import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_user_request.freezed.dart';

part 'login_user_request.g.dart';

@freezed
class LoginUserRequest with _$LoginUserRequest {
  const factory LoginUserRequest({
    final String? phone,
    final  String? password,
  }) = _LoginUserRequest;

  factory LoginUserRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginUserRequestFromJson(json);
}
