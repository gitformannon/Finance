import 'package:agro_card_delivery/features/auth/data/model/response/login_user_response.dart';
import 'package:agro_card_delivery/features/auth/domain/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../../data/model/request/login_user_request.dart';

class LoginUser extends UseCase<LoginUserResponse, LoginUserRequest> {
  final LoginRepository _repository;

  LoginUser(this._repository);

  @override
  Future<Either<Failure, LoginUserResponse>> call(
      LoginUserRequest params,
      ) async {
    return _repository.loginUser(request: params);
  }
}
