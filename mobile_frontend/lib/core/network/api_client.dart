import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/auth/data/model/request/login_user_request.dart';
import '../../features/auth/data/model/response/login_user_response.dart';
import '../../features/profile/data/model/profile_response.dart';
import '../constants/app_api.dart';
import '../constants/app_constants.dart';
import '../helpers/logger_helpers.dart';
import '../navigation/navigation_service.dart';
import '../storage/local_data_source.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(NavigationService navigation, LocalDataSource dataSource) {
    Dio dio = Dio(BaseOptions(
      followRedirects: false,
    ));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
          requestHeader: true,
          request: true,
          error: true,
          responseHeader: true,
        ),
      );
    }

    dio.options = BaseOptions(
        receiveTimeout: const Duration(milliseconds: AppConstants.dioTimeOut),
        connectTimeout: const Duration(milliseconds: AppConstants.dioTimeOut),
        sendTimeout: const Duration(milliseconds: AppConstants.dioTimeOut),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: (options, handler) async {
        String token = dataSource.getToken();
        String tokenType = dataSource.getTokenType();
        AppLoggerUtils.i(token);
        if (token.isNotEmpty) {
          options.headers['Authorization'] = "$tokenType $token";
        }
        return handler.next(options);
      }),
    ]);

    return _ApiClient(
      dio,
      baseUrl: AppApi.baseUrlProd,
    );
  }

  /// USH:AUTH

  @POST(AppApi.login)
  Future<LoginUserResponse> loginUser(@Body() LoginUserRequest request);

  @GET(AppApi.me)
  Future<ProfileResponse> getProfile();

  @POST(AppApi.logout)
  Future<void> logout();


}
