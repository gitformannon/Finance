class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.isIncome = true,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final amt = json['amount'] as num? ?? 0;
    return Transaction(
      id: json['id']?.toString() ?? '',
      title: json['description'] as String? ?? '',
      amount: amt.toDouble(),
      date: DateTime.parse(json['created_at'] as String),
      isIncome: amt >= 0,
    );
  }
}
