class UpdateGoalRequest {
  final String id;
  final String? name;
  final int? targetAmount;
  final String? targetDate; // yyyy-MM-dd
  final String? emoji;

  UpdateGoalRequest({required this.id, this.name, this.targetAmount, this.targetDate, this.emoji});

  Map<String, dynamic> toJson() => {
        'name': name,
        'target_amount': targetAmount,
        'target_date': targetDate,
        'emoji': emoji,
      }..removeWhere((k, v) => v == null);
}

