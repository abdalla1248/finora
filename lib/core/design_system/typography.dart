import 'package:flutter/material.dart';

class FinoraTypography {
  const FinoraTypography._();

  static const String fontName = 'Inter';

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontName,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      height: 1.25,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontName,
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      height: 1.28,
      fontFeatures: [FontFeature.tabularFigures()],
    ),
    titleLarge: TextStyle(
      fontFamily: fontName,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      height: 1.33,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontName,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      height: 1.42,
    ),
    labelSmall: TextStyle(
      fontFamily: fontName,
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      height: 1.45,
    ),
  );
}
