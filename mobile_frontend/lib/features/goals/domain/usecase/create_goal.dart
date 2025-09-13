import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/create_goal_request.dart';
import '../repository/goals_repository.dart';

class CreateGoal {
  final GoalsRepository _repo;
  CreateGoal(this._repo);

  Future<Either<Failure, void>> call(CreateGoalRequest request) => _repo.createGoal(request);
}

