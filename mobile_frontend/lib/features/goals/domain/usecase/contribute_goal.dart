import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/goal.dart';
import '../repository/goals_repository.dart';

class ContributeGoal {
  final GoalsRepository _repo;
  ContributeGoal(this._repo);

  Future<Either<Failure, Goal>> call(String goalId, int amount) => _repo.contribute(goalId, amount);
}

