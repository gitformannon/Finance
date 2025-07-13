import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/profile_repository.dart';
import '../../data/model/profile_response.dart';

class UploadProfileImage extends UseCase<ProfileResponse, UploadProfileImageParams> {
  final ProfileRepository _repository;
  UploadProfileImage(this._repository);

  @override
  Future<Either<Failure, ProfileResponse>> call(UploadProfileImageParams params) {
    return _repository.uploadProfileImage(params.file);
  }
}

class UploadProfileImageParams {
  final File file;
  UploadProfileImageParams(this.file);
}
