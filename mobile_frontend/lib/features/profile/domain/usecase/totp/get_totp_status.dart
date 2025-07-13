import 'package:dartz/dartz.dart';
import '../../../../../core/network/failure.dart';
import '../../../../../core/network/use_case.dart';
import '../../repository/totp_repository.dart';
import '../../../data/model/totp_status_response.dart';
import '../../../../../core/network/no_params.dart';

class GetTotpStatus extends UseCase<TotpStatusResponse, NoParams> {
  final TotpRepository _repository;
  GetTotpStatus(this._repository);

  @override
  Future<Either<Failure, TotpStatusResponse>> call(NoParams params) {
    return _repository.status();
  }
}
