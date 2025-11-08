import 'package:bloc/bloc.dart';
import '../../core/helpers/enums_helpers.dart';
import '../../core/network/failure.dart';

/// Base cubit that provides centralized error handling
abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  /// Centralized error handling method
  void handleError(Failure failure, T Function(T state) stateUpdater) {
    emit(stateUpdater(state));
  }

  /// Helper method to emit loading state
  void emitLoading(T Function(T state) stateUpdater) {
    emit(stateUpdater(state));
  }

  /// Helper method to emit success state
  void emitSuccess(T Function(T state) stateUpdater) {
    emit(stateUpdater(state));
  }
}

/// Base state class with common fields
abstract class BaseState {
  final RequestStatus status;
  final String? errorMessage;

  const BaseState({
    this.status = RequestStatus.initial,
    this.errorMessage,
  });

  /// Copy with method that should be implemented by subclasses
  BaseState copyWith({
    RequestStatus? status,
    String? errorMessage,
  });
}
