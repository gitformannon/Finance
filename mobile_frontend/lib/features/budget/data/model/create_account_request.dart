class CreateAccountRequest {
  final String? accountName;
  final String? accountNumber;
  final int? accountType;
  final int initialBalance;

  CreateAccountRequest({
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.initialBalance = 0,
  });

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
        'account_type': accountType,
        'initial_balance': initialBalance,
      };
}
