import 'package:flutter/material.dart';

class FinoraTokens {
  const FinoraTokens._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double screenMarginMobile = md;
  static const double screenMarginTablet = lg;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusCircular = 999.0;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);

  static const EdgeInsets marginScreenMobile = EdgeInsets.symmetric(
    horizontal: screenMarginMobile,
  );
  static const EdgeInsets marginScreenTablet = EdgeInsets.symmetric(
    horizontal: screenMarginTablet,
  );

  static const List<BoxShadow> elevation0 = [];

  static const List<BoxShadow> elevation1 = [
    BoxShadow(color: Color(0x0F0F172A), blurRadius: 4.0, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> elevation2 = [
    BoxShadow(color: Color(0x1F0F172A), blurRadius: 8.0, offset: Offset(0, 4)),
  ];
}
