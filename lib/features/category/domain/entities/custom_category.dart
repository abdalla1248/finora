import 'package:equatable/equatable.dart';
import '../../../transaction/domain/entities/transaction.dart';

class CustomCategory extends Equatable {
  final String id;
  final String name;
  final TransactionType type;
  final String iconData;
  final String colorHex;
  final bool isArchived;

  const CustomCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.iconData,
    required this.colorHex,
    this.isArchived = false,
  });

  CustomCategory copyWith({
    String? id,
    String? name,
    TransactionType? type,
    String? iconData,
    String? colorHex,
    bool? isArchived,
  }) {
    return CustomCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconData: iconData ?? this.iconData,
      colorHex: colorHex ?? this.colorHex,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [id, name, type, iconData, colorHex, isArchived];
}
