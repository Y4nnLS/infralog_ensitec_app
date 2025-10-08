import 'package:flutter/material.dart';

/// Extensões para deixar o código da UI mais limpo.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
}
