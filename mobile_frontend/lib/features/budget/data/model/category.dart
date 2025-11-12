import '../../../../core/helpers/enums_helpers.dart';

class Category {
  final String id;
  final String name;
  final CategoryType type;
  final int? budget;
  final String? emoji_path;

  Category({required this.id, required this.name, required this.type, this.budget, this.emoji_path});

  factory Category.fromJson(Map<String, dynamic> json) {
    final dynamic rawType = json['type'];

    CategoryType type;
    if (rawType is int) {
      type = CategoryTypeX.fromValue(rawType);
    } else if (rawType is String) {
      final parsed = int.tryParse(rawType);
      if (parsed != null) {
        type = CategoryTypeX.fromValue(parsed);
      } else {
        type = CategoryTypeX.fromString(rawType);
      }
    } else {
      type = CategoryType.income;
    }

    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      type: type,
      budget: (json['budget'] as num?)?.toInt(),
      emoji_path: json['emoji_path'] as String?,
    );
  }
}
