import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AnalyticsInsight extends Equatable {
  final String id;
  final String titleKey;
  final String value;
  final String descriptionKey;
  final IconData icon;
  final Color color;

  const AnalyticsInsight({
    required this.id,
    required this.titleKey,
    required this.value,
    required this.descriptionKey,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, titleKey, value, descriptionKey, icon, color];
}
