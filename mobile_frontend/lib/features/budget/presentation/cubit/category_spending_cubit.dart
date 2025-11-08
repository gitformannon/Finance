import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/get_transactions_by_query.dart';
import 'package:intl/intl.dart';

class CategorySpendingState extends Equatable {
  final RequestStatus status;
  final Map<String, int> categorySpent; // categoryId -> amount
  final int year;
  final int month;

  const CategorySpendingState({
    this.status = RequestStatus.initial,
    this.categorySpent = const {},
    this.year = 0,
    this.month = 0,
  });

  CategorySpendingState copyWith({
    RequestStatus? status,
    Map<String, int>? categorySpent,
    int? year,
    int? month,
  }) {
    return CategorySpendingState(
      status: status ?? this.status,
      categorySpent: categorySpent ?? this.categorySpent,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }

  int getCategorySpent(String categoryId) {
    return categorySpent[categoryId] ?? 0;
  }

  @override
  List<Object?> get props => [status, categorySpent, year, month];
}

class CategorySpendingCubit extends Cubit<CategorySpendingState> {
  final GetTransactionsByQuery _getTransactionsByQuery;

  CategorySpendingCubit(this._getTransactionsByQuery) : super(const CategorySpendingState());

  Future<void> loadMonthlyCategorySpent(DateTime monthDate) async {
    // Check if we already have data for this month
    if (state.year == monthDate.year && 
        state.month == monthDate.month && 
        state.status == RequestStatus.loaded) {
      return; // Already loaded
    }

    emit(state.copyWith(status: RequestStatus.loading));
    
    try {
      final String monthQuery = DateFormat('yyyy-MM').format(monthDate);
      final Map<String, int> sums = {};

      final result = await _getTransactionsByQuery(GetTransactionsByQueryParams(monthQuery));
      result.fold(
        (failure) => emit(
          state.copyWith(status: RequestStatus.error),
        ),
        (txs) {
          for (final tx in txs) {
            if (!tx.isIncome && tx.categoryId != null && tx.categoryId!.isNotEmpty) {
              final key = tx.categoryId!;
              final amount = tx.amount.abs().round();
              sums.update(key, (prev) => prev + amount, ifAbsent: () => amount);
            }
          }
          emit(
            state.copyWith(
              status: RequestStatus.loaded,
              categorySpent: sums,
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

