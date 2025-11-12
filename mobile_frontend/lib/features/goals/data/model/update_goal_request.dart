class UpdateGoalRequest {
  final String id;
  final String? name;
  final int? targetAmount;
  final String? targetDate; // yyyy-MM-dd
  final String? emoji_path;

  UpdateGoalRequest({required this.id, this.name, this.targetAmount, this.targetDate, this.emoji_path});

  Map<String, dynamic> toJson() => {
        'name': name,
        'target_amount': targetAmount,
        'target_date': targetDate,
        'emoji_path': emoji_path,
      }..removeWhere((k, v) => v == null);
}

