import '../../../../core/helpers/enums_helpers.dart';

class CreateCategoryRequest {
  final String name;
  final CategoryType type;
  final int? budget;
  final String? emoji_path;

  CreateCategoryRequest({required this.name, required this.type, this.budget, this.emoji_path});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.value,
        'budget': budget,
        'emoji_path': emoji_path,
      }..removeWhere((key, value) => value == null);
}
