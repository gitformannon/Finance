import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/profile_response.dart';

mixin ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, ProfileResponse>> updateProfile(String firstName, String lastName);
}
