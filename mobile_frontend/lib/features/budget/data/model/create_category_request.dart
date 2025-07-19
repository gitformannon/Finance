class CreateCategoryRequest {
  final String name;
  final String type;

  CreateCategoryRequest({required this.name, required this.type});

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
      };
}
