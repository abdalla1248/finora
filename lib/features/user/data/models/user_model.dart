import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String preferredCurrencyCode;

  @HiveField(3)
  final String preferredLanguage;

  @HiveField(4)
  final String themeMode;

  @HiveField(5)
  final bool onboardingCompleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime lastOpenedAt;

  @HiveField(8)
  final String? profileImagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.preferredCurrencyCode,
    required this.preferredLanguage,
    required this.themeMode,
    this.profileImagePath,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.lastOpenedAt,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      preferredCurrencyCode: user.preferredCurrencyCode,
      preferredLanguage: user.preferredLanguage,
      themeMode: user.themeMode,
      profileImagePath: user.profileImagePath,
      onboardingCompleted: user.onboardingCompleted,
      createdAt: user.createdAt,
      lastOpenedAt: user.lastOpenedAt,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      preferredCurrencyCode: preferredCurrencyCode,
      preferredLanguage: preferredLanguage,
      themeMode: themeMode,
      profileImagePath: profileImagePath,
      onboardingCompleted: onboardingCompleted,
      createdAt: createdAt,
      lastOpenedAt: lastOpenedAt,
    );
  }
}
