import '../../../../core/helpers/enums_helpers.dart';

class CreateCategoryRequest {
  final String name;
  final CategoryType type;
  final int? budget;
  final String? emoji;

  CreateCategoryRequest({required this.name, required this.type, this.budget, this.emoji});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.value,
        'budget': budget,
        'emoji': emoji,
      }..removeWhere((key, value) => value == null);
}
