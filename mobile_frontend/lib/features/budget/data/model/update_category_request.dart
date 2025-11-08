class UpdateCategoryRequest {
  final String id;
  final String? name;
  final int? type; // 1 income, -1 purchase
  final int? budget;
  final String? emoji;

  UpdateCategoryRequest({required this.id, this.name, this.type, this.budget, this.emoji});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'budget': budget,
        'emoji': emoji,
      }..removeWhere((k, v) => v == null);
}

