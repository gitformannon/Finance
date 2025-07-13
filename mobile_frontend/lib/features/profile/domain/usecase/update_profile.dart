import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/profile_repository.dart';
import '../../data/model/profile_response.dart';

class UpdateProfile extends UseCase<ProfileResponse, UpdateProfileParams> {
  final ProfileRepository _repository;
  UpdateProfile(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.firstName, params.lastName);
  }
}

class UpdateProfileParams {
  final String firstName;
  final String lastName;
  const UpdateProfileParams({required this.firstName, required this.lastName});
}
