import 'package:flutter/material.dart';

/// Tema claro/escuro com tipografia e cores base.
/// Use Theme.of(context) para acessar nas telas e widgets.
class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(centerTitle: true),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
