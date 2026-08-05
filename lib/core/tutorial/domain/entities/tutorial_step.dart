import 'package:flutter/material.dart';

class TutorialStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final Alignment cardAlignment;

  const TutorialStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.cardAlignment = Alignment.bottomCenter,
  });
}
