/// Domain model for Account - separate from data model
class Account {
  final String id;
  final String name;
  final String? accountNumber;
  final String? institution;
  final int accountType;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.name,
    this.accountNumber,
    this.institution,
    required this.accountType,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Domain-specific business logic
  String get typeName {
    const types = {
      1: 'Debit card',
      2: 'Credit card',
      3: 'Savings',
      4: 'Investment',
      5: 'Cash',
      6: 'Other',
    };
    return types[accountType] ?? 'Unknown';
  }

  bool get hasInstitution => institution != null && institution!.isNotEmpty;

  /// Factory method to create from data model
  factory Account.fromDataModel(dynamic dataModel) {
    return Account(
      id: dataModel.id,
      name: dataModel.name,
      accountNumber: dataModel.accountNumber,
      institution: dataModel.institution,
      accountType: dataModel.accountType,
      balance: dataModel.balance,
      createdAt: DateTime.tryParse(dataModel.createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(dataModel.updatedAt) ?? DateTime.now(),
    );
  }
}
