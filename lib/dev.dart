import 'package:flutter/material.dart';
import 'app.dart';

/// Entry de desenvolvimento: aqui você injeta configs de DEV.
/// Se quiser, passe envs via --dart-define (abaixo).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App()); // você pode estender o App p/ aceitar env/config
}
