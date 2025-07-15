import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/transaction.dart';

class GetTransactionsByDate extends UseCase<List<Transaction>, GetTransactionsByDateParams> {
  final BudgetRepository _repository;
  GetTransactionsByDate(this._repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(GetTransactionsByDateParams params) {
    return _repository.transactionsByDate(params.date);
  }
}

class GetTransactionsByDateParams {
  final DateTime date;
  const GetTransactionsByDateParams(this.date);
}
