import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/totp/get_totp_status.dart';
import '../../domain/usecase/totp/enable_totp.dart';
import '../../domain/usecase/totp/confirm_totp.dart';
import '../../domain/usecase/totp/disable_totp.dart';
import '../../domain/usecase/totp/confirm_totp.dart' as c;
import '../../domain/usecase/totp/disable_totp.dart' as d;
import '../../domain/usecase/totp/get_totp_status.dart' as s;
import '../../domain/usecase/totp/enable_totp.dart' as e;
import '../../../../core/network/no_params.dart';

class TotpState extends Equatable {
  final RequestStatus status;
  final bool isEnabled;
  final bool awaitingConfirmation;
  final String qr;
  final String errorMessage;

  const TotpState({
    this.status = RequestStatus.initial,
    this.isEnabled = false,
    this.awaitingConfirmation = false,
    this.qr = '',
    this.errorMessage = '',
  });

  TotpState copyWith({
    RequestStatus? status,
    bool? isEnabled,
    bool? awaitingConfirmation,
    String? qr,
    String? errorMessage,
  }) {
    return TotpState(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      awaitingConfirmation: awaitingConfirmation ?? this.awaitingConfirmation,
      qr: qr ?? this.qr,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isEnabled, awaitingConfirmation, qr, errorMessage];
}

class TotpCubit extends Cubit<TotpState> {
  final s.GetTotpStatus _status;
  final e.EnableTotp _enable;
  final c.ConfirmTotp _confirm;
  final d.DisableTotp _disable;

  TotpCubit(this._status, this._enable, this._confirm, this._disable)
      : super(const TotpState());

  Future<void> loadStatus() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _status(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (data) => emit(state.copyWith(status: RequestStatus.loaded, isEnabled: data.isEnabled)),
    );
  }

  Future<void> enable() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _enable(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (data) => emit(state.copyWith(status: RequestStatus.loaded, awaitingConfirmation: true, qr: data.qrPngBase64)),
    );
  }

  Future<void> confirm(String code) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _confirm(c.ConfirmTotpParams(code));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded, isEnabled: true, awaitingConfirmation: false, qr: '')),
    );
  }

  Future<void> disable(String code) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _disable(d.DisableTotpParams(code));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded, isEnabled: false)),
    );
  }
}
