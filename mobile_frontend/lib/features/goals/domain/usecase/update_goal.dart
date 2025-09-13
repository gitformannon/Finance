import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/goal.dart';
import '../../data/model/update_goal_request.dart';
import '../../data/repository/goals_repository_impl.dart';

class UpdateGoal {
  final GoalsRepositoryImpl _repo;
  UpdateGoal(this._repo);
  Future<Either<Failure, Goal>> call(UpdateGoalRequest req) => _repo.updateGoal(req);
}

