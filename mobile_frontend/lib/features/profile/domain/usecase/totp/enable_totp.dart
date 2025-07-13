import 'package:dartz/dartz.dart';
import '../../../../../core/network/failure.dart';
import '../../../../../core/network/use_case.dart';
import '../../repository/totp_repository.dart';
import '../../../data/model/totp_setup_response.dart';
import '../../../../../core/network/no_params.dart';

class EnableTotp extends UseCase<TotpSetupResponse, NoParams> {
  final TotpRepository _repository;
  EnableTotp(this._repository);

  @override
  Future<Either<Failure, TotpSetupResponse>> call(NoParams params) {
    return _repository.enable();
  }
}
