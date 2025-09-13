import 'package:bloc/bloc.dart';
import '../../data/model/goal.dart';
import '../../domain/usecase/get_goals.dart';
import '../../domain/usecase/create_goal.dart';
import '../../domain/usecase/contribute_goal.dart';
import '../../domain/usecase/update_goal.dart';
import '../../data/model/update_goal_request.dart';
import '../../data/model/create_goal_request.dart';

class GoalsState {
  final List<Goal> goals;
  final bool loading;
  final String? error;
  const GoalsState({this.goals = const [], this.loading = false, this.error});

  GoalsState copyWith({List<Goal>? goals, bool? loading, String? error}) =>
      GoalsState(
        goals: goals ?? this.goals,
        loading: loading ?? this.loading,
        error: error,
      );
}

class GoalsCubit extends Cubit<GoalsState> {
  final GetGoals _getGoals;
  final CreateGoal _createGoal;
  final ContributeGoal _contributeGoal;
  final UpdateGoal? _updateGoal;
  GoalsCubit(this._getGoals, this._createGoal, this._contributeGoal, [this._updateGoal]) : super(const GoalsState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    final res = await _getGoals();
    res.fold(
      (l) => emit(state.copyWith(loading: false, error: l.errorMessage)),
      (r) => emit(GoalsState(goals: r, loading: false)),
    );
  }

  Future<void> create(String name, int targetAmount, {String? targetDate, int initialAmount = 0}) async {
    emit(state.copyWith(loading: true, error: null));
    final res = await _createGoal(CreateGoalRequest(name: name, targetAmount: targetAmount, targetDate: targetDate, initialAmount: initialAmount));
    await res.fold((l) async {
      emit(state.copyWith(loading: false, error: l.errorMessage));
    }, (_) async {
      await load();
    });
  }

  Future<void> contribute(String goalId, int amount) async {
    final res = await _contributeGoal(goalId, amount);
    res.fold((l) => null, (updated) {
      final idx = state.goals.indexWhere((g) => g.id == goalId);
      if (idx >= 0) {
        final copy = [...state.goals];
        copy[idx] = updated;
        emit(state.copyWith(goals: copy));
      }
    });
  }

  Future<void> update({required String id, String? name, int? targetAmount, String? targetDate}) async {
    if (_updateGoal == null) return;
    final res = await _updateGoal!(UpdateGoalRequest(id: id, name: name, targetAmount: targetAmount, targetDate: targetDate));
    res.fold((l) => null, (updated) {
      final idx = state.goals.indexWhere((g) => g.id == id);
      if (idx >= 0) {
        final copy = [...state.goals];
        copy[idx] = updated;
        emit(state.copyWith(goals: copy));
      }
    });
  }
}
