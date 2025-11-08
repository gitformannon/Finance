import 'package:bloc/bloc.dart';
import '../../domain/usecase/create_goal.dart';
import '../../data/model/create_goal_request.dart';
import '../../../../core/helpers/enums_helpers.dart';
import 'add_goal_state.dart';

class AddGoalCubit extends Cubit<AddGoalState> {
  final CreateGoal _createGoal;
  AddGoalCubit(this._createGoal) : super(const AddGoalState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setTargetAmount(int v) => emit(state.copyWith(targetAmount: v));
  void setTargetDate(DateTime? v) => emit(state.copyWith(targetDate: v));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateGoalRequest(
      name: state.name,
      targetAmount: state.targetAmount,
      targetDate: state.targetDate != null
          ? '${state.targetDate!.year.toString().padLeft(4, '0')}-${state.targetDate!.month.toString().padLeft(2, '0')}-${state.targetDate!.day.toString().padLeft(2, '0')}'
          : null,
    );
    final result = await _createGoal(request);
    result.fold(
      (l) => emit(state.copyWith(status: RequestStatus.error, errorMessage: l.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
