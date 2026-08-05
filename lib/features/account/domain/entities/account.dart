import 'package:equatable/equatable.dart';

enum AccountType {
  cash,
  bank,
  savings,
  creditCard,
  wallet,
  business;

  String get nameString => name;
}

class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currencyCode;
  final String? colorHex;
  final String? iconData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  final bool isDefault;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    this.balance = 0.0,
    required this.currencyCode,
    this.colorHex,
    this.iconData,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
    this.isDefault = false,
  });

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currencyCode,
    String? colorHex,
    String? iconData,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    bool? isDefault,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currencyCode: currencyCode ?? this.currencyCode,
      colorHex: colorHex ?? this.colorHex,
      iconData: iconData ?? this.iconData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    balance,
    currencyCode,
    colorHex,
    iconData,
    createdAt,
    updatedAt,
    isArchived,
    isDefault,
  ];
}
