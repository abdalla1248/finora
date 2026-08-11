import 'package:flutter/material.dart';

import 'responsive_breakpoints.dart';

class ResponsiveCenteredView extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenteredView({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveBreakpoints.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue<double>(
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 0),
        child: Padding(
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16.0,
              ),
          child: child,
        ),
      ),
    );
  }
}
