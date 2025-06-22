class Transaction {
  final int id;
  final double amount;
  final String category;
  final String date;
  final String account;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.account,
  });

  // Фабричный конструктор для создания объекта из JSON (словаря)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: json['date'] as String,
      account: json['account'] as String? ?? '',
    );
  }
}