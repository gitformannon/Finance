import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/account.dart';

class GetAccounts extends UseCase<List<Account>, NoParams> {
  final BudgetRepository _repository;
  GetAccounts(this._repository);

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) {
    return _repository.getAccounts();
  }
}
