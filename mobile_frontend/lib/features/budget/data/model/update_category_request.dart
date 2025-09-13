class UpdateCategoryRequest {
  final String id;
  final String? name;
  final int? type; // 1 income, -1 purchase
  final int? budget;

  UpdateCategoryRequest({required this.id, this.name, this.type, this.budget});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'budget': budget,
      }..removeWhere((k, v) => v == null);
}

