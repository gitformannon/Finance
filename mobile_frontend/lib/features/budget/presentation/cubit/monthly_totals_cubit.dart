import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/get_transactions_by_query.dart';
import 'package:intl/intl.dart';

class MonthlyTotalsState extends Equatable {
  final RequestStatus status;
  final int income;
  final int expense;
  final int year;
  final int month;

  const MonthlyTotalsState({
    this.status = RequestStatus.initial,
    this.income = 0,
    this.expense = 0,
    this.year = 0,
    this.month = 0,
  });

  MonthlyTotalsState copyWith({
    RequestStatus? status,
    int? income,
    int? expense,
    int? year,
    int? month,
  }) {
    return MonthlyTotalsState(
      status: status ?? this.status,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [status, income, expense, year, month];
}

class MonthlyTotalsCubit extends Cubit<MonthlyTotalsState> {
  final GetTransactionsByQuery _getTransactionsByQuery;

  MonthlyTotalsCubit(this._getTransactionsByQuery) : super(const MonthlyTotalsState());

  Future<void> loadMonthlyTotals(DateTime monthDate) async {
    // Check if we already have data for this month
    if (state.year == monthDate.year && 
        state.month == monthDate.month && 
        state.status == RequestStatus.loaded) {
      return; // Already loaded
    }

    emit(state.copyWith(status: RequestStatus.loading));
    
    try {
      final String monthQuery = DateFormat('yyyy-MM').format(monthDate);
      int income = 0;
      int expense = 0;

      final result = await _getTransactionsByQuery(GetTransactionsByQueryParams(monthQuery));
      result.fold(
        (failure) => emit(
          state.copyWith(status: RequestStatus.error),
        ),
        (txs) {
          for (final tx in txs) {
            if (tx.isIncome) {
              income += tx.amount.abs().round();
            } else {
              expense += tx.amount.abs().round();
            }
          }
          emit(
            state.copyWith(
              status: RequestStatus.loaded,
              income: income,
              expense: expense,
              year: monthDate.year,
              month: monthDate.month,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(status: RequestStatus.error));
    }
  }
}

