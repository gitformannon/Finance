import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_api.dart';
import '../../../../core/network/response_handler.dart';
import '../../../../core/network/server_error.dart';
import '../../data/model/request/login_user_request.dart';
import '../../data/model/request/refresh_token_request.dart';
import '../../data/model/response/login_user_response.dart';

/// Contract for login data source.
abstract class LoginDataSource {
  Future<ResponseHandler<LoginUserResponse>> loginUser({
    required LoginUserRequest request,
  });

  Future<ResponseHandler<LoginUserResponse>> refreshToken({
    required RefreshTokenRequest request,
  });
}

/// Implementation that performs OAuth2 password flow using [Dio].
class LoginDataSourceImpl implements LoginDataSource {
  @override
  Future<ResponseHandler<LoginUserResponse>> loginUser({
    required LoginUserRequest request,
  }) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppApi.baseUrlProd));
      final resp = await dio.post(
        AppApi.login,
        data: request.toMap(),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final data = LoginUserResponse.fromJson(
        resp.data as Map<String, dynamic>,
      );
      return ResponseHandler()..data = data;
    } catch (error, stacktrace) {
      debugPrint('Exception occurred: $error stacktrace: $stacktrace');
      final serverError = error is DioException
          ? ServerError.withError(error: error)
          : ServerError.withError(
              error: DioException(
                  requestOptions: RequestOptions(path: ''),
                  error: error.toString()));
      return ResponseHandler()..setException(serverError);
    }
  }

  @override
  Future<ResponseHandler<LoginUserResponse>> refreshToken({
    required RefreshTokenRequest request,
  }) async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppApi.baseUrlProd));
      final resp = await dio.post(
        AppApi.rToken,
        data: request.toJson(),
      );
      final data = LoginUserResponse.fromJson(
        resp.data as Map<String, dynamic>,
      );
      return ResponseHandler()..data = data;
    } catch (error, stacktrace) {
      debugPrint('Exception occurred: $error stacktrace: $stacktrace');
      final serverError = error is DioException
          ? ServerError.withError(error: error)
          : ServerError.withError(
              error: DioException(
                  requestOptions: RequestOptions(path: ''),
                  error: error.toString()));
      return ResponseHandler()..setException(serverError);
    }
  }
}
