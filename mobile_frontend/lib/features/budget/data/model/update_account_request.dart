class UpdateAccountRequest {
  final String id;
  final String? accountName;
  final String? accountNumber;
  final int? accountType;
  final String? institution;
  final String? emoji;

  UpdateAccountRequest({
    required this.id,
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.institution,
    this.emoji,
  });

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
        'account_type': accountType,
        'institution': institution,
        'emoji': emoji,
      }..removeWhere((k, v) => v == null);
}

