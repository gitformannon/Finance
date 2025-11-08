class CreateGoalRequest {
  final String name;
  final int targetAmount;
  final String? targetDate; // yyyy-MM-dd
  final int initialAmount;
  final String? emoji;

  CreateGoalRequest({
    required this.name,
    required this.targetAmount,
    this.targetDate,
    this.initialAmount = 0,
    this.emoji,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'target_amount': targetAmount,
        'target_date': targetDate,
        'initial_amount': initialAmount,
        'emoji': emoji,
      }..removeWhere((key, value) => value == null);
}

