import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'state/product_controller.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/local_storage.dart';

/// App raiz: registra dependências (Providers), tema e rotas.
/// Mantém a inicialização limpa e centralizada.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Injeção manual simples (sem get_it): criamos as instâncias aqui
    final apiClient = ApiClient(baseUrl: 'https://fakestoreapi.com'); // exemplo
    final storage = LocalStorage();
    final productRepo = ProductRepository(apiClient, storage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductController(productRepo)..loadInitial(),
        ),
      ],
      child: MaterialApp(
        title: 'Catálogo Nerd',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
