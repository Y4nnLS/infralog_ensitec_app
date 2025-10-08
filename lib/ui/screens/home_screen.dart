import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/product_controller.dart';
import '../../core/routing/app_router.dart';
import '../widgets/product_card.dart';
import '../widgets/app_button.dart';
import '../../core/extensions/context_ext.dart';

/// Tela inicial: busca, lista, feedback de loading/erro.
/// Exemplo de composição com widgets reutilizáveis.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo Nerd')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // BUSCA
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<ProductController>().search('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (v) => context.read<ProductController>().search(v),
            ),
            const SizedBox(height: 12),

            // FEEDBACK DE LOADING/ERRO
            if (ctrl.loading) const LinearProgressIndicator(),
            if (ctrl.error != null)
              Text(ctrl.error!, style: TextStyle(color: context.colors.error)),

            const SizedBox(height: 8),

            // LISTA
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<ProductController>().loadInitial(),
                child: ListView.separated(
                  itemCount: ctrl.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = ctrl.items[i];
                    return ProductCard(
                      product: p,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.productDetail,
                          arguments: {'product': p},
                        );
                      },
                      onToggleFavorite: () =>
                          context.read<ProductController>().toggleFavorite(p),
                    );
                  },
                ),
              ),
            ),

            // EXEMPLO DE COMPONENTE BOTÃO REUTILIZÁVEL
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Recarregar',
                    icon: Icons.refresh,
                    onPressed: () => context.read<ProductController>().loadInitial(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
