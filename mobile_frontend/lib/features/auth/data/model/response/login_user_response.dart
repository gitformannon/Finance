import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_user_response.freezed.dart';

part 'login_user_response.g.dart';

@freezed
class LoginUserResponse with _$LoginUserResponse {
  const factory LoginUserResponse(
      {@Default(false) bool success,
      @Default("") String message,
      final LoginData? data}) = _LoginUserResponse;

  factory LoginUserResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginUserResponseFromJson(json);
}

@freezed
class LoginData with _$LoginData {
  const factory LoginData(
      {@Default("") String accessToken,
      @Default("") String role,
      @Default("") String name,
      @Default("") String phone,
     }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
