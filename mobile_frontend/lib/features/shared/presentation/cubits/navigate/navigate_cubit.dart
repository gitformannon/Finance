import 'package:Finance/core/constants/app_routes.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/navigation/navigation_service.dart';

part 'navigate_state.dart';

part 'navigate_cubit.freezed.dart';

class NavigateCubit extends Cubit<NavigateState> {
  final NavigationService _navigationService;

  NavigateCubit(this._navigationService) : super(const NavigateState.initial());

  void goToMainPage() {
    _navigationService.navigateTo(AppRoutes.home);
  }

  void goToLoginPage() {
    _navigationService.navigateTo(AppRoutes.login);
  }
}
