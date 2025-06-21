import 'package:features/shared/domain/repository/shared_repository.dart';

import '../../../../core/storage/local_data_source.dart';

class SharedRepositoryImpl with SharedRepository {
  final LocalDataSource _localDataSource;

  SharedRepositoryImpl(this._localDataSource);

  @override
  String getToken() {
    return _localDataSource.getToken();
  }

  @override
  Future<void> setToken(String token) async {
    await _localDataSource.setUserToken(token);
  }
}
