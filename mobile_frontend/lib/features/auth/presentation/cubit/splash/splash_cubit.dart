import 'package:agro_card_delivery/core/constants/time_delay.dart';
import 'package:agro_card_delivery/features/shared/domain/repository/shared_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '/core/helpers/enums_helpers.dart';

part 'splash_cubit.freezed.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SharedRepository _repository;

  SplashCubit(this._repository) : super(const SplashState()){
    getTokenAndNavigate();
  }

  void getTokenAndNavigate() async {
    await Future.delayed(TimeDelays.twoSeconds);
    var token = _repository.getToken();
    if (token.isNotEmpty) {
      emit(state.copyWith(status: RequestStatus.loaded));
    } else {
      emit(state.copyWith(status: RequestStatus.loaded));
    }
  }
}
