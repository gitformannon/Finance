import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/transaction.dart';
import '../../data/model/create_transaction_request.dart';
import '../../data/model/create_account_request.dart';
import '../../data/model/category.dart';

mixin BudgetRepository {
  Future<Either<Failure, List<Transaction>>> transactionsByDate(DateTime date);
  Future<Either<Failure, void>> createTransaction(CreateTransactionRequest request);
  Future<Either<Failure, void>> createAccount(CreateAccountRequest request);
  Future<Either<Failure, List<Category>>> getCategories(String type);
}
