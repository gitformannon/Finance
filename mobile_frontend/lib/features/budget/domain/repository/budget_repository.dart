import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/transaction.dart';

mixin BudgetRepository {
  Future<Either<Failure, List<Transaction>>> transactionsByDate(DateTime date);
}
