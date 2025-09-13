import '../../../../core/helpers/enums_helpers.dart';

class CreateCategoryRequest {
  final String name;
  final CategoryType type;
  final int? budget;

  CreateCategoryRequest({required this.name, required this.type, this.budget});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.value,
        'budget': budget,
      }..removeWhere((key, value) => value == null);
}
