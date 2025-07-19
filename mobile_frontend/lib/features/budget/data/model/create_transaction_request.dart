class CreateTransactionRequest {
  final String type;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final double amount;
  final String note;
  final String date;

  CreateTransactionRequest({
    required this.type,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'account_id': accountId,
        if (toAccountId != null) 'to_account_id': toAccountId,
        if (categoryId != null) 'category_id': categoryId,
        'amount': amount,
        'note': note,
        'date': date,
      };
}
