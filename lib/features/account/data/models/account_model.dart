import 'package:hive/hive.dart';
import '../../domain/entities/account.dart';

part 'account_model.g.dart';

@HiveType(typeId: 4)
class AccountModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final double balance;

  @HiveField(4)
  final String currencyCode;

  @HiveField(5)
  final String? colorHex;

  @HiveField(6)
  final String? iconData;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final bool isArchived;

  @HiveField(10)
  final bool isDefault;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currencyCode,
    this.colorHex,
    this.iconData,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
    required this.isDefault,
  });

  factory AccountModel.fromEntity(Account entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      type: entity.type.name,
      balance: entity.balance,
      currencyCode: entity.currencyCode,
      colorHex: entity.colorHex,
      iconData: entity.iconData,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isArchived: entity.isArchived,
      isDefault: entity.isDefault,
    );
  }

  Account toEntity() {
    return Account(
      id: id,
      name: name,
      type: AccountType.values.firstWhere(
        (a) => a.name == type,
        orElse: () => AccountType.cash,
      ),
      balance: balance,
      currencyCode: currencyCode,
      colorHex: colorHex,
      iconData: iconData,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isArchived: isArchived,
      isDefault: isDefault,
    );
  }
}
