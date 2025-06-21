part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
     final RequestStatus? status,
    final LoginUserResponse? data,
    @Default("") String? errorMessage,
    @Default(false) bool phoneError,
    @Default(false) bool passwordError,
  }) = _LoginState;
}
