// lib/core/utils/logger.dart
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Uso:
/// logI('ProductController', 'Loaded ${items.length}');
/// logE('ApiClient', e, st);
///
/// Em Debug:
///  - envia para debugPrint (console rápido, sem travar)
///  - envia para dev.log (aparece no DevTools)
/// Em Release:
///  - não faz nada (no-op), evitando log acidental em produção.

void logI(String tag, String message) {
  if (kDebugMode) {
    debugPrint('[I][$tag] $message');
    dev.log(message, name: tag, level: 800); // INFO
  }
}

void logW(String tag, String message) {
  if (kDebugMode) {
    debugPrint('[W][$tag] $message');
    dev.log(message, name: tag, level: 900); // WARNING
  }
}

void logE(String tag, Object error, [StackTrace? st]) {
  if (kDebugMode) {
    debugPrint('[E][$tag] $error');
    if (st != null) debugPrint(st.toString());
    dev.log(error.toString(), name: tag, level: 1000, stackTrace: st); // SEVERE
  }
}
