class Category {
  final String id;
  final String name;
  final String type;

  Category({required this.id, required this.name, required this.type});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );
}
