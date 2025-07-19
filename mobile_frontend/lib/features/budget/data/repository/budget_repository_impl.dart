import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repository/budget_repository.dart';
import '../model/transaction.dart';
import '../model/create_transaction_request.dart';
import '../model/create_account_request.dart';
import '../model/category.dart';

class BudgetRepositoryImpl with BudgetRepository {
  final ApiClient _client;
  BudgetRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<Transaction>>> transactionsByDate(DateTime date) async {
    try {
      final resp = await _client.getTransactions(date.toIso8601String());
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createTransaction(CreateTransactionRequest request) async {
    try {
      await _client.createTransaction(request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAccount(CreateAccountRequest request) async {
    try {
      await _client.createAccount(request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories(String type) async {
    try {
      final resp = await _client.getCategories(type);
      return Right(resp.map((e) => Category.fromJson(e)).toList());
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
