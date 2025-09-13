import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/goal.dart';
import '../repository/goals_repository.dart';

class GetGoals {
  final GoalsRepository _repo;
  GetGoals(this._repo);

  Future<Either<Failure, List<Goal>>> call() => _repo.getGoals();
}

