import 'package:dartz/dartz.dart';
import '../../../../../core/network/failure.dart';
import '../../../../../core/network/use_case.dart';
import '../../repository/totp_repository.dart';

class DisableTotp extends UseCase<void, DisableTotpParams> {
  final TotpRepository _repository;
  DisableTotp(this._repository);

  @override
  Future<Either<Failure, void>> call(DisableTotpParams params) {
    return _repository.disable(params.code);
  }
}

class DisableTotpParams {
  final String code;
  DisableTotpParams(this.code);
}
