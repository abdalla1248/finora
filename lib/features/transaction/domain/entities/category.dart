import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'transaction.dart';

class Category extends Equatable {
  final String id;
  final String nameKey;
  final TransactionType type;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.nameKey,
    required this.type,
    required this.icon,
    required this.color,
  });

  String getLocalizedName(dynamic l10n) {
    switch (nameKey) {
      case 'categoryFood':
        return l10n.categoryFood;
      case 'categoryTransportation':
        return l10n.categoryTransportation;
      case 'categoryShopping':
        return l10n.categoryShopping;
      case 'categoryEntertainment':
        return l10n.categoryEntertainment;
      case 'categoryBills':
        return l10n.categoryBills;
      case 'categoryHealth':
        return l10n.categoryHealth;
      case 'categoryEducation':
        return l10n.categoryEducation;
      case 'categoryTravel':
        return l10n.categoryTravel;
      case 'categorySubscription':
        return l10n.categorySubscription;
      case 'categorySalary':
        return l10n.categorySalary;
      case 'categoryFreelance':
        return l10n.categoryFreelance;
      case 'categoryBusiness':
        return l10n.categoryBusiness;
      case 'categoryInvestment':
        return l10n.categoryInvestment;
      case 'categoryGift':
        return l10n.categoryGift;
      case 'categoryTransfer':
        return l10n.categoryTransfer;
      default:
        return l10n.categoryOther;
    }
  }

  @override
  List<Object?> get props => [id, nameKey, type, icon, color];
}

class CategoryRegistry {
  const CategoryRegistry._();

  static const List<Category> defaultCategories = [
    // Expense Categories
    Category(
      id: 'food',
      nameKey: 'categoryFood',
      type: TransactionType.expense,
      icon: Icons.restaurant,
      color: Color(0xFFEF4444),
    ),
    Category(
      id: 'transportation',
      nameKey: 'categoryTransportation',
      type: TransactionType.expense,
      icon: Icons.directions_bus,
      color: Color(0xFFF59E0B),
    ),
    Category(
      id: 'shopping',
      nameKey: 'categoryShopping',
      type: TransactionType.expense,
      icon: Icons.shopping_bag,
      color: Color(0xFFEC4899),
    ),
    Category(
      id: 'entertainment',
      nameKey: 'categoryEntertainment',
      type: TransactionType.expense,
      icon: Icons.movie,
      color: Color(0xFF8B5CF6),
    ),
    Category(
      id: 'bills',
      nameKey: 'categoryBills',
      type: TransactionType.expense,
      icon: Icons.receipt_long,
      color: Color(0xFF3B82F6),
    ),
    Category(
      id: 'health',
      nameKey: 'categoryHealth',
      type: TransactionType.expense,
      icon: Icons.medical_services,
      color: Color(0xFF10B981),
    ),
    Category(
      id: 'education',
      nameKey: 'categoryEducation',
      type: TransactionType.expense,
      icon: Icons.school,
      color: Color(0xFF6366F1),
    ),
    Category(
      id: 'travel',
      nameKey: 'categoryTravel',
      type: TransactionType.expense,
      icon: Icons.flight,
      color: Color(0xFF06B6D4),
    ),
    Category(
      id: 'subscription',
      nameKey: 'categorySubscription',
      type: TransactionType.expense,
      icon: Icons.subscriptions,
      color: Color(0xFF14B8A6),
    ),
    Category(
      id: 'expense_other',
      nameKey: 'categoryOther',
      type: TransactionType.expense,
      icon: Icons.more_horiz,
      color: Color(0xFF64748B),
    ),

    // Income Categories
    Category(
      id: 'salary',
      nameKey: 'categorySalary',
      type: TransactionType.income,
      icon: Icons.work,
      color: Color(0xFF10B981),
    ),
    Category(
      id: 'freelance',
      nameKey: 'categoryFreelance',
      type: TransactionType.income,
      icon: Icons.computer,
      color: Color(0xFF3B82F6),
    ),
    Category(
      id: 'business',
      nameKey: 'categoryBusiness',
      type: TransactionType.income,
      icon: Icons.store,
      color: Color(0xFF8B5CF6),
    ),
    Category(
      id: 'investment',
      nameKey: 'categoryInvestment',
      type: TransactionType.income,
      icon: Icons.trending_up,
      color: Color(0xFFF59E0B),
    ),
    Category(
      id: 'gift',
      nameKey: 'categoryGift',
      type: TransactionType.income,
      icon: Icons.card_giftcard,
      color: Color(0xFFEC4899),
    ),
    Category(
      id: 'income_other',
      nameKey: 'categoryOther',
      type: TransactionType.income,
      icon: Icons.attach_money,
      color: Color(0xFF64748B),
    ),

    // Transfer Category
    Category(
      id: 'transfer',
      nameKey: 'categoryTransfer',
      type: TransactionType.transfer,
      icon: Icons.swap_horiz,
      color: Color(0xFF6366F1),
    ),
  ];

  static Category getCategoryById(String id) {
    return defaultCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => const Category(
        id: 'unknown',
        nameKey: 'categoryOther',
        type: TransactionType.expense,
        icon: Icons.help_outline,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  static List<Category> getCategoriesForType(TransactionType type) {
    return defaultCategories.where((c) => c.type == type).toList();
  }
}
