import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/no_params.dart';
import '../../../../core/network/use_case.dart';
import '../repository/profile_repository.dart';

class LogoutUser extends UseCase<void, NoParams> {
  final ProfileRepository _repository;
  LogoutUser(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.logout();
  }
}
