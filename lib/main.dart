import 'dart:async';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'bootstrap/bootstrap.dart';
import 'core/logging/logger.dart';

void main() {
  runZonedGuarded(
    () async {
      final rootWidget = await Bootstrap.run(() => const FinoraApp());
      runApp(rootWidget);
    },
    (error, stackTrace) {
      AppLogger.error(
        'Unhandled async critical error occurred.',
        error,
        stackTrace,
      );
    },
  );
}
