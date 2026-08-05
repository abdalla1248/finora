import 'dart:async';
import 'package:flutter/material.dart';
import '../core/di/injection.dart';
import '../core/logging/logger.dart';

class Bootstrap {
  const Bootstrap._();

  /// Runs app initialization steps before launching root widget.
  static Future<Widget> run(FutureOr<Widget> Function() builder) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Redirect Flutter Framework errors to structured logs
    FlutterError.onError = (details) {
      AppLogger.error(
        'Flutter framework error caught.',
        details.exception,
        details.stack,
      );
    };

    try {
      AppLogger.info('Starting dependency injection setup...');
      await DIContainer.setup();
      AppLogger.info('Bootstrap setup successfully finalized.');
    } catch (e, stackTrace) {
      AppLogger.error('Critical failure during app bootstrap.', e, stackTrace);
      rethrow;
    }

    return await builder();
  }
}
