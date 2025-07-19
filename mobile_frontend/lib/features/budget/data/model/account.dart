class Account {
  final String id;
  final String? name;
  final String? number;
  final int? type;
  final int balance;

  Account({
    required this.id,
    this.name,
    this.number,
    this.type,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id']?.toString() ?? '',
      name: json['account_name'] as String?,
      number: json['account_number'] as String?,
      type: json['account_type'] is int
          ? json['account_type'] as int
          : int.tryParse(json['account_type']?.toString() ?? ''),
      balance: (json['balance'] as num? ?? 0).toInt(),
    );
  }
}
