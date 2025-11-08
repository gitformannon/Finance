/// Domain model for Goal - separate from data model
class Goal {
  final String id;
  final String name;
  final int targetAmount;
  final int currentAmount;
  final DateTime? targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Domain-specific business logic
  double get progressPercentage {
    if (targetAmount == 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  bool get isCompleted => currentAmount >= targetAmount;

  int get remainingAmount => (targetAmount - currentAmount).clamp(0, targetAmount);

  /// Factory method to create from data model
  factory Goal.fromDataModel(dynamic dataModel) {
    return Goal(
      id: dataModel.id,
      name: dataModel.name,
      targetAmount: dataModel.targetAmount,
      currentAmount: dataModel.currentAmount,
      targetDate: dataModel.targetDate != null 
          ? DateTime.tryParse(dataModel.targetDate) 
          : null,
      createdAt: DateTime.tryParse(dataModel.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(dataModel.updatedAt) ?? DateTime.now(),
    );
  }
}
