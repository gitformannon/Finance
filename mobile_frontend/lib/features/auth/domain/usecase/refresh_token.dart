import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/no_params.dart';
import '../../../../core/network/use_case.dart';
import '../../data/model/response/login_user_response.dart';
import '../repository/login_repository.dart';

class RefreshToken extends UseCase<LoginUserResponse, NoParams> {
  final LoginRepository _repository;
  RefreshToken(this._repository);

  @override
  Future<Either<Failure, LoginUserResponse>> call(NoParams params) {
    return _repository.refreshToken();
  }
}
