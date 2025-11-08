import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/helpers/enums_helpers.dart';

part 'add_goal_state.freezed.dart';

@freezed
class AddGoalState with _$AddGoalState {
  const factory AddGoalState({
    @Default('') String name,
    @Default(0) int targetAmount,
    DateTime? targetDate,
    String? emoji,
    @Default(RequestStatus.initial) RequestStatus status,
    String? errorMessage,
  }) = _AddGoalState;
}
