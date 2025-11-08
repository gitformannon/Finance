import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/goal.dart';

part 'goals_state.freezed.dart';

@freezed
class GoalsState with _$GoalsState {
  const factory GoalsState({
    @Default([]) List<Goal> goals,
    @Default(false) bool loading,
    String? error,
  }) = _GoalsState;
}
