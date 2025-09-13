import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repository/goals_repository.dart';
import '../model/create_goal_request.dart';
import '../model/goal.dart';
import '../model/update_goal_request.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  final ApiClient _client;
  GoalsRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<Goal>>> getGoals() async {
    try {
      final resp = await _client.getGoals();
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createGoal(CreateGoalRequest request) async {
    try {
      await _client.createGoal(request.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Goal>> contribute(String goalId, int amount) async {
    try {
      final resp = await _client.contributeToGoal(goalId, {'amount': amount});
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, Goal>> updateGoal(UpdateGoalRequest request) async {
    try {
      final resp = await _client.updateGoal(request.id, request.toJson());
      return Right(resp);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
