import 'package:flutter/material.dart';

abstract class ResponsiveBreakpoints {
  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;
  static const double maxContentWidth = 900.0;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < ResponsiveBreakpoints.mobileMax;
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.mobileMax &&
      screenWidth <= ResponsiveBreakpoints.tabletMax;
  bool get isDesktop => screenWidth > ResponsiveBreakpoints.tabletMax;

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  EdgeInsets get responsivePadding {
    final horizontal = responsiveValue<double>(
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 16.0);
  }
}
