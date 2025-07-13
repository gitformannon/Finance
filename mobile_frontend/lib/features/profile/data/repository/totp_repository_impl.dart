import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repository/totp_repository.dart';
import '../model/totp_code_request.dart';
import '../model/totp_setup_response.dart';
import '../model/totp_status_response.dart';

class TotpRepositoryImpl with TotpRepository {
  final ApiClient _client;
  TotpRepositoryImpl(this._client);

  @override
  Future<Either<Failure, TotpStatusResponse>> status() async {
    try {
      final resp = await _client.totpStatus();
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TotpSetupResponse>> enable() async {
    try {
      final resp = await _client.enableTotp();
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirm(String code) async {
    try {
      await _client.confirmTotp(TotpCodeRequest(code: code));
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disable(String code) async {
    try {
      await _client.disableTotp(TotpCodeRequest(code: code));
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
