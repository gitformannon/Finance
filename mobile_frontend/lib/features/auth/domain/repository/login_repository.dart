import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/request/login_user_request.dart';
import '../../data/model/response/login_user_response.dart';

mixin LoginRepository {
  Future<Either<Failure,LoginUserResponse>> loginUser({
    required LoginUserRequest request,
  });

  Future<Either<Failure, LoginUserResponse>> refreshToken();
}
