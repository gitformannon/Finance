import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../data/model/create_goal_request.dart';
import '../repository/goals_repository.dart';
import '../../domain/usecase/get_goals.dart';

/// Enhanced CreateGoal use case that handles business logic
class CreateGoalEnhanced {
  final GoalsRepository _repository;
  final GetGoals _getGoals;

  CreateGoalEnhanced(this._repository, this._getGoals);

  Future<Either<Failure, void>> call(CreateGoalRequest request) async {
    // Business logic: validate the request
    if (request.name.trim().isEmpty) {
      return Left(Failure(errorMessage: 'Goal name cannot be empty'));
    }
    
    if (request.targetAmount <= 0) {
      return Left(Failure(errorMessage: 'Target amount must be greater than 0'));
    }

    if (request.targetDate != null) {
      final targetDate = DateTime.tryParse(request.targetDate!);
      if (targetDate == null || targetDate.isBefore(DateTime.now())) {
        return Left(Failure(errorMessage: 'Target date must be in the future'));
      }
    }

    // Create the goal
    final result = await _repository.createGoal(request);
    
    // Business logic: refresh the goals list after creation
    return result.fold(
      (failure) => Left(failure),
      (_) async {
        // This is business logic that was previously in the cubit
        await _getGoals();
        return const Right(null);
      },
    );
  }
}
