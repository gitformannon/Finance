class UpdateCategoryRequest {
  final String id;
  final String? name;
  final int? type; // 1 income, -1 purchase
  final int? budget;
  final String? emoji_path;

  UpdateCategoryRequest({required this.id, this.name, this.type, this.budget, this.emoji_path});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'budget': budget,
        'emoji_path': emoji_path,
      }..removeWhere((k, v) => v == null);
}

