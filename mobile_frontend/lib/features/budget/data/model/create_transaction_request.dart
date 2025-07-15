class CreateTransactionRequest {
  final String type;
  final String accountId;
  final String? toAccountId;
  final double amount;
  final String note;
  final String date;

  CreateTransactionRequest({
    required this.type,
    required this.accountId,
    this.toAccountId,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'account_id': accountId,
        if (toAccountId != null) 'to_account_id': toAccountId,
        'amount': amount,
        'note': note,
        'date': date,
      };
}
