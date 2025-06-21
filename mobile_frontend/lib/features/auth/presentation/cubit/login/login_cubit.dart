import 'package:bloc/bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/helpers/enums_helpers.dart';
import '../../../data/model/request/login_user_request.dart';
import '../../../data/model/response/login_user_response.dart';
import '../../../domain/usecase/login_user.dart';

part 'login_state.dart';

part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser loginUserUseCase;

  LoginCubit(this.loginUserUseCase) : super(const LoginState());

  Future<void> login({String phone = "", String password = ""}) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = LoginUserRequest(phone: phone, password: password);
    final result = await loginUserUseCase(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ), // Failure — Left
      (response) =>
          emit(state.copyWith(status: RequestStatus.loaded)), // Success — Right
    );
  }
}
