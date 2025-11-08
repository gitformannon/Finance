import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/transaction.dart';

class GetTransactionsByQuery extends UseCase<List<Transaction>, GetTransactionsByQueryParams> {
  final BudgetRepository _repository;
  GetTransactionsByQuery(this._repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(GetTransactionsByQueryParams params) {
    // Parse the query string to DateTime
    DateTime date;
    if (params.query.length == 4) {
      // YYYY format
      date = DateTime(int.parse(params.query), 1, 1);
    } else if (params.query.length == 7) {
      // YYYY-MM format
      final parts = params.query.split('-');
      date = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
    } else if (params.query.length == 10) {
      // YYYY-MM-DD format
      final parts = params.query.split('-');
      date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    } else {
      // Default to current date
      date = DateTime.now();
    }
    
    return _repository.transactionsByDate(date);
  }
}

class GetTransactionsByQueryParams {
  final String query; // 'YYYY', 'YYYY-MM', or 'YYYY-MM-DD'
  const GetTransactionsByQueryParams(this.query);
}

