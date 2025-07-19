import '../../../../core/helpers/enums_helpers.dart';

class CreateCategoryRequest {
  final String name;
  final CategoryType type;

  CreateCategoryRequest({required this.name, required this.type});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
      };
}
