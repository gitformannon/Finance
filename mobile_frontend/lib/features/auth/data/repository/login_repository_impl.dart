import 'package:Finance/core/network/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/storage/local_data_source.dart';
import '../../domain/data_source/login_data_source.dart';
import '../../domain/repository/login_repository.dart';
import '../model/request/login_user_request.dart';
import '../model/request/refresh_token_request.dart';
import '../model/response/login_user_response.dart';

class LoginRepositoryImpl with LoginRepository {
  final LocalDataSource _localDataSource;
  final LoginDataSource _loginDataSource;

  LoginRepositoryImpl(this._localDataSource, this._loginDataSource);

  @override
  Future<Either<Failure, LoginUserResponse>> loginUser({
    required LoginUserRequest request,
  }) async {
    try {
      final response = await _loginDataSource.loginUser(request: request);
      if (response.data != null) {
        final data = response.data ??
            const LoginUserResponse(
              accessToken: '',
              refreshToken: '',
              tokenType: '',
              userId: '',
            );
        final token = data.accessToken;
        if (token.isNotEmpty) {
          await _localDataSource.setUserToken(token);
          await _localDataSource.setRefreshToken(data.refreshToken);
          await _localDataSource.setTokenType(data.tokenType);
        }
        return Right(data);
      } else {
        return Left(
          Failure(
            errorMessage: response.getException()?.getErrorMessage() ?? "Error",
          ),
        );
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginUserResponse>> refreshToken() async {
    try {
      final refresh = _localDataSource.getRefreshToken();
      final response = await _loginDataSource.refreshToken(
        request: RefreshTokenRequest(refreshToken: refresh),
      );
      if (response.data != null) {
        final data = response.data!;
        if (data.accessToken.isNotEmpty) {
          await _localDataSource.setUserToken(data.accessToken);
          await _localDataSource.setRefreshToken(data.refreshToken);
          await _localDataSource.setTokenType(data.tokenType);
        }
        return Right(data);
      } else {
        return Left(
          Failure(
            errorMessage: response.getException()?.getErrorMessage() ?? 'Error',
          ),
        );
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
