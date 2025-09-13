import 'package:dartz/dartz.dart';

import 'package:intl/intl.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repository/budget_repository.dart';
import '../model/transaction.dart';
import '../model/create_transaction_request.dart';
import '../model/create_account_request.dart';
import '../model/account.dart';
import '../model/category.dart';
import '../model/create_category_request.dart';
import '../model/update_account_request.dart';
import '../model/update_category_request.dart';
import '../model/update_transaction_request.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final ApiClient _client;
  BudgetRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<Transaction>>> transactionsByDate(DateTime date) async {
    try {
      final formatted = DateFormat('yyyy-MM-dd').format(date);
      final resp = await _client.getTransactions(formatted);
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
  Future<Either<Failure, List<Account>>> getAccounts() async {
    try {
      final resp = await _client.getAccounts();
      return Right(resp);
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

  @override
  Future<Either<Failure, void>> createCategory(CreateCategoryRequest request) async {
    try {
      await _client.createCategory(request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAccount(UpdateAccountRequest request) async {
    try {
      await _client.updateAccount(request.id, request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(UpdateCategoryRequest request) async {
    try {
      await _client.updateCategory(request.id, request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(UpdateTransactionRequest request) async {
    try {
      await _client.updateTransaction(request.id, request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
