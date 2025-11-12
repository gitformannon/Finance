class UpdateAccountRequest {
  final String id;
  final String? accountName;
  final String? accountNumber;
  final int? accountType;
  final String? institution;
  final String? emoji_path;

  UpdateAccountRequest({
    required this.id,
    this.accountName,
    this.accountNumber,
    this.accountType,
    this.institution,
    this.emoji_path,
  });

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
        'account_type': accountType,
        'institution': institution,
        'emoji_path': emoji_path,
      }..removeWhere((k, v) => v == null);
}

