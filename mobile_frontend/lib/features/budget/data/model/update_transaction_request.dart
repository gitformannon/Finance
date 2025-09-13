class UpdateTransactionRequest {
  final String id;
  final String? categoryId;
  final String? note;

  UpdateTransactionRequest({required this.id, this.categoryId, this.note});

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'note': note,
      }..removeWhere((k, v) => v == null);
}

