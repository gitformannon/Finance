import '../../../../core/helpers/enums_helpers.dart';

class Category {
  final String id;
  final String name;
  final CategoryType type;

  Category({required this.id, required this.name, required this.type});

  factory Category.fromJson(Map<String, dynamic> json) {
    final dynamic rawType = json['type'];
    int? intType;
    if (rawType is int) {
      intType = rawType;
    } else if (rawType is String) {
      intType = int.tryParse(rawType);
    }
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      type: CategoryTypeX.fromValue(intType),
    );
  }
}
