import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String preferredCurrencyCode;
  final String preferredLanguage;
  final String themeMode;
  final String? profileImagePath;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime lastOpenedAt;

  const User({
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

  User copyWith({
    String? id,
    String? name,
    String? preferredCurrencyCode,
    String? preferredLanguage,
    String? themeMode,
    String? profileImagePath,
    bool? clearProfileImage,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? lastOpenedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      preferredCurrencyCode:
          preferredCurrencyCode ?? this.preferredCurrencyCode,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      themeMode: themeMode ?? this.themeMode,
      profileImagePath: clearProfileImage == true
          ? null
          : (profileImagePath ?? this.profileImagePath),
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    preferredCurrencyCode,
    preferredLanguage,
    themeMode,
    profileImagePath,
    onboardingCompleted,
    createdAt,
    lastOpenedAt,
  ];
}
