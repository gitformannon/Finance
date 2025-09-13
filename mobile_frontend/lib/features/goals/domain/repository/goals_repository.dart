import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/goal.dart';
import '../../data/model/create_goal_request.dart';

abstract class GoalsRepository {
  Future<Either<Failure, List<Goal>>> getGoals();
  Future<Either<Failure, void>> createGoal(CreateGoalRequest request);
  Future<Either<Failure, Goal>> contribute(String goalId, int amount);
}

