import 'package:dartz/dartz.dart';
import '../../../../core/network/failure.dart';
import '../../../../core/network/use_case.dart';
import '../repository/budget_repository.dart';
import '../../data/model/category.dart';

class GetCategories extends UseCase<List<Category>, GetCategoriesParams> {
  final BudgetRepository _repository;
  GetCategories(this._repository);

  @override
  Future<Either<Failure, List<Category>>> call(GetCategoriesParams params) {
    return _repository.getCategories(params.type);
  }
}

class GetCategoriesParams {
  final String type;
  GetCategoriesParams(this.type);
}
