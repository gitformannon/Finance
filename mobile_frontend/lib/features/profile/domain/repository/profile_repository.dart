import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/profile_response.dart';
import 'dart:io';

mixin ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, ProfileResponse>> updateProfile(String firstName, String lastName);
  Future<Either<Failure, ProfileResponse>> uploadProfileImage(File file);
}
