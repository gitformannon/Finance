import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/create_transaction_request.dart';

class AddTransaction extends UseCase<void, AddTransactionParams> {
  final BudgetRepository _repository;
  AddTransaction(this._repository);

  @override
  Future<Either<Failure, void>> call(AddTransactionParams params) {
    return _repository.createTransaction(params.request);
  }
}

class AddTransactionParams {
  final CreateTransactionRequest request;
  AddTransactionParams(this.request);
}
