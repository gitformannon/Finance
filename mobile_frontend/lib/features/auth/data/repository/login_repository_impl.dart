import 'package:Finance/core/network/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/storage/local_data_source.dart';
import '../../domain/data_source/login_data_source.dart';
import '../../domain/repository/login_repository.dart';
import '../model/request/login_user_request.dart';
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
        return Right(response.data ?? LoginUserResponse());
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
}
