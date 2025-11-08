import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../domain/usecase/get_categories.dart';
import '../../data/model/category.dart';

class CategoriesListState extends Equatable {
  final RequestStatus status;
  final List<Category> categories;
  final String errorMessage;

  const CategoriesListState({
    this.status = RequestStatus.initial,
    this.categories = const [],
    this.errorMessage = '',
  });

  CategoriesListState copyWith({
    RequestStatus? status,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoriesListState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Category> get expenseCategories {
    return categories.where((c) => c.type == CategoryType.purchase).toList();
  }

  @override
  List<Object?> get props => [status, categories, errorMessage];
}

class CategoriesListCubit extends Cubit<CategoriesListState> {
  final GetCategories _getCategories;

  CategoriesListCubit(this._getCategories) : super(const CategoriesListState());

  Future<void> loadExpenseCategories() async {
    emit(state.copyWith(status: RequestStatus.loading));
    
    final result = await _getCategories(GetCategoriesParams('purchase'));
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: RequestStatus.loaded,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    await loadExpenseCategories();
  }
}

