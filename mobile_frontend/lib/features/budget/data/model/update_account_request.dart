class UpdateAccountRequest {
  final String id;
  final String? accountName;
  final String? accountNumber;
  final int? accountType;
  final String? institution;

  UpdateAccountRequest({
    required this.id,
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.institution,
  });

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
        'account_type': accountType,
        'institution': institution,
      }..removeWhere((k, v) => v == null);
}

