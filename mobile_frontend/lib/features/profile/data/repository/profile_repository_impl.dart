import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/storage/local_data_source.dart';
import '../model/logout_request.dart';
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
      return Right(resp);
    } catch (e) {
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
}
