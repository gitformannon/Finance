import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/add_category.dart';
import '../../data/model/create_category_request.dart';
import 'transaction_cubit.dart';

class CategoryState extends Equatable {
  final String name;
  final TransactionType type;
  final RequestStatus status;
  final String errorMessage;

  const CategoryState({
    this.name = '',
    this.type = TransactionType.income,
    this.status = RequestStatus.initial,
    this.errorMessage = '',
  });

  CategoryState copyWith({
    String? name,
    TransactionType? type,
    RequestStatus? status,
    String? errorMessage,
  }) => CategoryState(
        name: name ?? this.name,
        type: type ?? this.type,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [name, type, status, errorMessage];
}

class CategoryCubit extends Cubit<CategoryState> {
  final AddCategory _addCategory;
  CategoryCubit(this._addCategory) : super(const CategoryState());

  void setName(String v) => emit(state.copyWith(name: v));
  void setType(TransactionType t) => emit(state.copyWith(type: t));

  Future<void> submit() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final request = CreateCategoryRequest(name: state.name, type: state.type.name);
    final result = await _addCategory(AddCategoryParams(request));
    result.fold(
      (l) => emit(state.copyWith(status: RequestStatus.error, errorMessage: l.errorMessage)),
      (_) => emit(state.copyWith(status: RequestStatus.loaded)),
    );
  }
}
