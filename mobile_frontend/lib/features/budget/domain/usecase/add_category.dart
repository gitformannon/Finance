import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/create_category_request.dart';

class AddCategory extends UseCase<void, AddCategoryParams> {
  final BudgetRepository _repository;
  AddCategory(this._repository);

  @override
  Future<Either<Failure, void>> call(AddCategoryParams params) {
    return _repository.createCategory(params.request);
  }
}

class AddCategoryParams {
  final CreateCategoryRequest request;
  AddCategoryParams(this.request);
}
