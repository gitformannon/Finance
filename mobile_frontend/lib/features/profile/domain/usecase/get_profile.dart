import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/no_params.dart';
import '../../../../core/network/use_case.dart';
import '../repository/profile_repository.dart';
import '../../data/model/profile_response.dart';

class GetProfile extends UseCase<ProfileResponse, NoParams> {
  final ProfileRepository _repository;
  GetProfile(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> call(NoParams params) {
    return _repository.getProfile();
  }
}
