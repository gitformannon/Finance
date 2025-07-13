import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/totp_status_response.dart';
import '../../data/model/totp_setup_response.dart';

mixin TotpRepository {
  Future<Either<Failure, TotpStatusResponse>> status();
  Future<Either<Failure, TotpSetupResponse>> enable();
  Future<Either<Failure, void>> confirm(String code);
  Future<Either<Failure, void>> disable(String code);
}
