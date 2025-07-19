import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/create_account_request.dart';

class AddAccount extends UseCase<void, AddAccountParams> {
  final BudgetRepository _repository;
  AddAccount(this._repository);

  @override
  Future<Either<Failure, void>> call(AddAccountParams params) {
    return _repository.createAccount(params.request);
  }
}

class AddAccountParams {
  final CreateAccountRequest request;
  AddAccountParams(this.request);
}
