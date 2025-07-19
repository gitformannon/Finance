import '../../../../core/helpers/enums_helpers.dart';

class Category {
  final String id;
  final String name;
  final CategoryType type;

  Category({required this.id, required this.name, required this.type});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        type: CategoryTypeX.fromString(json['type'] as String? ?? ''),
      );
}
