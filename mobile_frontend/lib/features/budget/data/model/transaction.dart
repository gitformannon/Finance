class Transaction {
  final String id;
  final String title; // kept for compatibility, mapped from description
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String? accountName;
  final String? categoryName;
  final String? categoryId;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.isIncome = true,
    this.accountName,
    this.categoryName,
    this.categoryId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final amt = json['amount'] as num? ?? 0;
    return Transaction(
      id: json['id']?.toString() ?? '',
      title: json['description'] as String? ?? '',
      amount: amt.toDouble(),
      date: DateTime.parse(json['created_at'] as String),
      isIncome: amt >= 0,
      accountName: json['account_name'] as String?,
      categoryName: json['category_name'] as String?,
      categoryId: json['category_id']?.toString(),
    );
  }
}
