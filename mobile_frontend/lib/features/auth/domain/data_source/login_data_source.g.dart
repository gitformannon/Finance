// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_source.dart';

// **************************************************************************
// SubclassGenerator
// **************************************************************************

class LoginDataSourceImpl with LoginDataSource {
  final ApiClient _apiClient;
  LoginDataSourceImpl(this._apiClient);

  @override
  Future<ResponseHandler<LoginUserResponse>> loginUser({
    required LoginUserRequest request,
  }) async {
    LoginUserResponse? response;
    try {
      response = await _apiClient.loginUser(
        request,
      );
      return ResponseHandler()..data = response;
    } catch (error, stacktrace) {
      debugPrint("Exception occurred: $error stacktrace: $stacktrace");
      final serverError = error is DioException
          ? ServerError.withError(error: error) // ✅ Safe Cast
          : ServerError.withError(
              error: DioException(
                  requestOptions: RequestOptions(path: ""),
                  error: error.toString())); // ✅ Handle other errors
      return ResponseHandler()..setException(serverError);
    }
  }
}
