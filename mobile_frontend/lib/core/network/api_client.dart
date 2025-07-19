import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/auth/data/model/request/login_user_request.dart';
import '../../features/auth/data/model/response/login_user_response.dart';
import '../../features/profile/data/model/profile_response.dart';
import '../../features/profile/data/model/logout_request.dart';
import '../../features/profile/data/model/update_profile_request.dart';
import '../../features/profile/data/model/totp_setup_response.dart';
import '../../features/profile/data/model/totp_status_response.dart';
import '../../features/profile/data/model/totp_code_request.dart';
import '../../features/auth/data/model/request/refresh_token_request.dart';
import '../../features/budget/data/model/transaction.dart';
import '../../features/budget/data/model/account.dart';
import '../constants/app_api.dart';
import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
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
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = dataSource.getToken();
          String tokenType = dataSource.getTokenType();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = "$tokenType $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final reqPath = error.requestOptions.path;
          if (statusCode == 401 &&
              reqPath != AppApi.r_token &&
              reqPath != AppApi.login) {
            final refresh = dataSource.getRefreshToken();
            if (refresh.isNotEmpty) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: AppApi.baseUrlProd));
                final resp = await refreshDio.post(
                  AppApi.r_token,
                  data: RefreshTokenRequest(refreshToken: refresh).toJson(),
                );
                final newData = LoginUserResponse.fromJson(
                    resp.data as Map<String, dynamic>);
                if (newData.accessToken.isNotEmpty) {
                  await dataSource.setUserToken(newData.accessToken);
                  await dataSource.setRefreshToken(newData.refreshToken);
                  await dataSource.setTokenType(newData.tokenType);
                  error.requestOptions.headers['Authorization'] =
                      '${newData.tokenType} ${newData.accessToken}';
                  final clonedRequest = await dio.fetch(error.requestOptions);
                  return handler.resolve(clonedRequest);
                }
              } catch (_) {
                navigation.navigateTo(AppRoutes.login);
                await dataSource.setUserToken('');
                await dataSource.setRefreshToken('');
                await dataSource.setTokenType('');
              }
            }
          }
          return handler.next(error);
        },
      ),
    ]);

    return _ApiClient(
      dio,
      baseUrl: AppApi.baseUrlProd,
    );
  }

  /// USH:AUTH

  @POST(AppApi.login)
  Future<LoginUserResponse> loginUser(@Body() LoginUserRequest request);

  @POST(AppApi.r_token)
  Future<LoginUserResponse> refreshToken(
      @Body() RefreshTokenRequest request,
  );

  @GET(AppApi.me)
  Future<ProfileResponse> getProfile();

  @PUT(AppApi.me)
  Future<ProfileResponse> updateProfile(@Body() UpdateProfileRequest request);

  @MultiPart()
  @POST(AppApi.profileImage)
  Future<ProfileResponse> uploadProfileImage(
      @Part(name: 'file') MultipartFile file,
  );

  @POST(AppApi.logout)
  Future<void> logout(@Body() LogoutRequest request);

  @GET(AppApi.totp_status)
  Future<TotpStatusResponse> totpStatus();

  @POST(AppApi.totp_enable)
  Future<TotpSetupResponse> enableTotp();

  @POST(AppApi.totp_confirm)
  Future<void> confirmTotp(@Body() TotpCodeRequest request);

  @POST(AppApi.totp_disable)
  Future<void> disableTotp(@Body() TotpCodeRequest request);

  @GET(AppApi.transactions)
  Future<List<Transaction>> getTransactions(@Query('date') String date);

  @POST(AppApi.transactions)
  Future<void> createTransaction(@Body() Map<String, dynamic> data);

  @GET(AppApi.accounts)
  Future<List<Account>> getAccounts();

  @POST(AppApi.accounts)
  Future<void> createAccount(@Body() Map<String, dynamic> data);

  @GET(AppApi.categories)
  Future<List<dynamic>> getCategories(@Query('type') String type);

  @POST(AppApi.categories)
  Future<void> createCategory(@Body() Map<String, dynamic> data);


}
