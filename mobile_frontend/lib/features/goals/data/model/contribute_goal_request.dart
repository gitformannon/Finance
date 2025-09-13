class ContributeGoalRequest {
  final int amount; // positive to add, negative to remove
  ContributeGoalRequest(this.amount);

  Map<String, dynamic> toJson() => {
        'amount': amount,
      };
}

