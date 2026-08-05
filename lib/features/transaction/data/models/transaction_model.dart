import 'package:hive/hive.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String transactionType;

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final String accountId;

  @HiveField(7)
  final String currencyCode;

  @HiveField(8)
  final DateTime transactionDate;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final List<String> tags;

  @HiveField(12)
  final String note;

  @HiveField(13)
  final String? attachmentPath;

  @HiveField(14)
  final bool isRecurring;

  @HiveField(15)
  final String? recurrenceRule;

  @HiveField(16)
  final String? location;

  @HiveField(17)
  final bool isDeleted;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.transactionType,
    required this.categoryId,
    required this.accountId,
    required this.currencyCode,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.note,
    this.attachmentPath,
    required this.isRecurring,
    this.recurrenceRule,
    this.location,
    required this.isDeleted,
  });

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      amount: entity.amount,
      transactionType: entity.transactionType.name,
      categoryId: entity.categoryId,
      accountId: entity.accountId,
      currencyCode: entity.currencyCode,
      transactionDate: entity.transactionDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tags: entity.tags,
      note: entity.note,
      attachmentPath: entity.attachmentPath,
      isRecurring: entity.isRecurring,
      recurrenceRule: entity.recurrenceRule,
      location: entity.location,
      isDeleted: entity.isDeleted,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      title: title,
      description: description,
      amount: amount,
      transactionType: TransactionType.values.firstWhere(
        (t) => t.name == transactionType,
        orElse: () => TransactionType.expense,
      ),
      categoryId: categoryId,
      accountId: accountId,
      currencyCode: currencyCode,
      transactionDate: transactionDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      note: note,
      attachmentPath: attachmentPath,
      isRecurring: isRecurring,
      recurrenceRule: recurrenceRule,
      location: location,
      isDeleted: isDeleted,
    );
  }
}
