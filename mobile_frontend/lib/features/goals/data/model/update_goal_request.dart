class UpdateGoalRequest {
  final String id;
  final String? name;
  final int? targetAmount;
  final String? targetDate; // yyyy-MM-dd

  UpdateGoalRequest({required this.id, this.name, this.targetAmount, this.targetDate});

  Map<String, dynamic> toJson() => {
        'name': name,
        'target_amount': targetAmount,
        'target_date': targetDate,
      }..removeWhere((k, v) => v == null);
}

