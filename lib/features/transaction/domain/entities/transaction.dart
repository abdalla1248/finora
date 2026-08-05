import 'package:equatable/equatable.dart';

enum TransactionType {
  expense,
  income,
  transfer;

  String get nameString => name;
}

class Transaction extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final TransactionType transactionType;
  final String categoryId;
  final String accountId;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String note;
  final String? attachmentPath;
  final bool isRecurring;
  final String? recurrenceRule;
  final String? location;
  final bool isDeleted;

  const Transaction({
    required this.id,
    required this.title,
    this.description = '',
    required this.amount,
    required this.transactionType,
    required this.categoryId,
    required this.accountId,
    required this.currencyCode,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.note = '',
    this.attachmentPath,
    this.isRecurring = false,
    this.recurrenceRule,
    this.location,
    this.isDeleted = false,
  });

  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    TransactionType? transactionType,
    String? categoryId,
    String? accountId,
    String? currencyCode,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? note,
    String? attachmentPath,
    bool? isRecurring,
    String? recurrenceRule,
    String? location,
    bool? isDeleted,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      note: note ?? this.note,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      location: location ?? this.location,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    amount,
    transactionType,
    categoryId,
    accountId,
    currencyCode,
    transactionDate,
    createdAt,
    updatedAt,
    tags,
    note,
    attachmentPath,
    isRecurring,
    recurrenceRule,
    location,
    isDeleted,
  ];
}
