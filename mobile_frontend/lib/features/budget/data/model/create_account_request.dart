class CreateAccountRequest {
  final String? accountName;
  final String? accountNumber;
  final int? accountType;
  final int initialBalance;
  final String? institution;
  final String? emoji;

  CreateAccountRequest({
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.initialBalance = 0,
    this.institution,
    this.emoji,
  });

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
      'account_type': accountType,
      'initial_balance': initialBalance,
      'institution': institution,
      'emoji': emoji,
      }..removeWhere((key, value) => value == null);
}
