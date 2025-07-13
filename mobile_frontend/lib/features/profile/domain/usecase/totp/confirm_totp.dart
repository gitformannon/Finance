import 'package:dartz/dartz.dart';
import '../../../../../core/network/failure.dart';
import '../../../../../core/network/use_case.dart';
import '../../repository/totp_repository.dart';

class ConfirmTotp extends UseCase<void, ConfirmTotpParams> {
  final TotpRepository _repository;
  ConfirmTotp(this._repository);

  @override
  Future<Either<Failure, void>> call(ConfirmTotpParams params) {
    return _repository.confirm(params.code);
  }
}

class ConfirmTotpParams {
  final String code;
  ConfirmTotpParams(this.code);
}
