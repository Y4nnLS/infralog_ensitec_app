import 'package:flutter/material.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/product_detail_screen.dart';

/// Rotas nomeadas centralizadas.
/// Vantagem: evita strings “mágicas” espalhadas.
class AppRouter {
  static const home = '/';
  static const productDetail = '/product/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case productDetail:
        // Espera um map com os argumentos necessários
        final args = settings.arguments as Map<String, dynamic>?;
        final product = args?['product'];
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
