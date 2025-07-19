import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../data/model/create_transaction_request.dart';
import '../../domain/usecase/add_transaction.dart';
import '../../domain/usecase/get_categories.dart';
import '../../data/model/category.dart';

enum TransactionType { income, purchase, transfer }

class TransactionState extends Equatable {
  final TransactionType type;
  final String accountId;
  final String toAccountId;
  final String categoryId;
  final List<Category> categories;
  final double amount;
  final DateTime date;
  final String note;
  final RequestStatus status;
  final String errorMessage;

  const TransactionState({
    this.type = TransactionType.transfer,
    this.accountId = '',
    this.toAccountId = '',
    this.categoryId = '',
    this.categories = const [],
    this.amount = 0,
    required this.date,
    this.note = '',
    this.status = RequestStatus.initial,
    this.errorMessage = '',
  });

  bool get isValid =>
      accountId.isNotEmpty &&
      categoryId.isNotEmpty &&
      amount > 0 &&
      (type != TransactionType.transfer || toAccountId.isNotEmpty);

  TransactionState copyWith({
    TransactionType? type,
    String? accountId,
    String? toAccountId,
    String? categoryId,
    List<Category>? categories,
    double? amount,
    DateTime? date,
    String? note,
    RequestStatus? status,
    String? errorMessage,
  }) {
    return TransactionState(
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      categories: categories ?? this.categories,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [type, accountId, toAccountId, categoryId, categories, amount, date, note, status, errorMessage];
}

class TransactionCubit extends Cubit<TransactionState> {
  final AddTransaction _addTransaction;
  final GetCategories _getCategories;
  TransactionCubit(this._addTransaction, this._getCategories)
      : super(TransactionState(date: DateTime.now()));

  void setType(TransactionType type) => emit(state.copyWith(type: type));
  void setAccountId(String id) => emit(state.copyWith(accountId: id));
  void setToAccountId(String id) => emit(state.copyWith(toAccountId: id));
  void setCategoryId(String id) => emit(state.copyWith(categoryId: id));
  void setAmount(double value) => emit(state.copyWith(amount: value));
  void setDate(DateTime date) => emit(state.copyWith(date: date));
  void setNote(String note) => emit(state.copyWith(note: note));

  Future<void> loadCategories() async {
    final result = await _getCategories(GetCategoriesParams(state.type.name));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.errorMessage)),
      (data) => emit(state.copyWith(categories: data)),
    );
  }

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateTransactionRequest(
      type: state.type.name,
      accountId: state.accountId,
      toAccountId: state.type == TransactionType.transfer ? state.toAccountId : null,
      categoryId: state.categoryId,
      amount: state.amount,
      note: state.note,
      date: DateFormat('yyyy-MM-dd').format(state.date),
    );
    final result = await _addTransaction(AddTransactionParams(request));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.error, errorMessage: failure.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
