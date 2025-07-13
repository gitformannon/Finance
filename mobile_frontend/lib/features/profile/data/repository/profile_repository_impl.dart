import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/storage/local_data_source.dart';
import '../model/logout_request.dart';
import '../model/update_profile_request.dart';
import '../../domain/repository/profile_repository.dart';
import '../model/profile_response.dart';

class ProfileRepositoryImpl with ProfileRepository {
  final ApiClient _client;
  final LocalDataSource _localDataSource;
  ProfileRepositoryImpl(this._client, this._localDataSource);

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final resp = await _client.getProfile();
      await _localDataSource.setUserId(resp.id);
      await _localDataSource.setUsername(resp.username);
      await _localDataSource.setEmail(resp.email);
      await _localDataSource.setFirstName(resp.firstName);
      await _localDataSource.setLastName(resp.lastName);
      if (resp.profileImage != null) {
        await _localDataSource.setProfileImagePath(resp.profileImage!);
      }
      return Right(resp);
    } catch (e) {
      try {
        final cached = ProfileResponse(
          id: _localDataSource.getUserId(),
          username: _localDataSource.getUsername(),
          email: _localDataSource.getEmail(),
          firstName: _localDataSource.getFirstName(),
          lastName: _localDataSource.getLastName(),
          profileImage: _localDataSource.getProfileImagePath(),
        );
        if (cached.id.isNotEmpty) {
          return Right(cached);
        }
      } catch (_) {}
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refresh = _localDataSource.getRefreshToken();
      await _client.logout(LogoutRequest(refresh: refresh));
    } catch (_) {}
    await _localDataSource.setUserToken('');
    await _localDataSource.setRefreshToken('');
    await _localDataSource.setTokenType('');
    return const Right(null);
  }

  @override
  Future<Either<Failure, ProfileResponse>> updateProfile(
      String firstName, String lastName) async {
    try {
      final resp = await _client
          .updateProfile(UpdateProfileRequest(firstName: firstName, lastName: lastName));
      await _localDataSource.setFirstName(resp.firstName);
      await _localDataSource.setLastName(resp.lastName);
      if (resp.profileImage != null) {
        await _localDataSource.setProfileImagePath(resp.profileImage!);
      }
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
