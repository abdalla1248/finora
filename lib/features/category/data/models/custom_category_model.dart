import 'package:hive/hive.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../domain/entities/custom_category.dart';

part 'custom_category_model.g.dart';

@HiveType(typeId: 5)
class CustomCategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String iconData;

  @HiveField(4)
  final String colorHex;

  @HiveField(5)
  final bool isArchived;

  CustomCategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconData,
    required this.colorHex,
    required this.isArchived,
  });

  factory CustomCategoryModel.fromEntity(CustomCategory entity) {
    return CustomCategoryModel(
      id: entity.id,
      name: entity.name,
      type: entity.type.name,
      iconData: entity.iconData,
      colorHex: entity.colorHex,
      isArchived: entity.isArchived,
    );
  }

  CustomCategory toEntity() {
    return CustomCategory(
      id: id,
      name: name,
      type: TransactionType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => TransactionType.expense,
      ),
      iconData: iconData,
      colorHex: colorHex,
      isArchived: isArchived,
    );
  }
}
