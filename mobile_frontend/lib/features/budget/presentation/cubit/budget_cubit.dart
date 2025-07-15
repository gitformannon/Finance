import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/get_transactions_by_date.dart';
import '../../data/model/transaction.dart';

class BudgetState extends Equatable {
  final RequestStatus status;
  final List<Transaction> transactions;
  final String errorMessage;
  final DateTime selectedDate;

  const BudgetState({
    this.status = RequestStatus.initial,
    this.transactions = const [],
    this.errorMessage = '',
    required this.selectedDate,
  });

  BudgetState copyWith({
    RequestStatus? status,
    List<Transaction>? transactions,
    String? errorMessage,
    DateTime? selectedDate,
  }) {
    return BudgetState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage, selectedDate];
}

class BudgetCubit extends Cubit<BudgetState> {
  final GetTransactionsByDate _getTransactions;

  BudgetCubit(this._getTransactions)
      : super(BudgetState(selectedDate: DateTime.now()));

  Future<void> load(DateTime date) async {
    emit(state.copyWith(status: RequestStatus.loading, selectedDate: date));
    final result = await _getTransactions(GetTransactionsByDateParams(date));
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage),
      ),
      (data) => emit(
        state.copyWith(status: RequestStatus.loaded, transactions: data),
      ),
    );
  }
}
