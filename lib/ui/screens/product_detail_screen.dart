import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/extensions/context_ext.dart';

/// Tela de detalhes. Recebe o Product por argumentos de rota.
/// Em apps maiores, prefira buscar por id no controller/repo.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem grande
            AspectRatio(
              aspectRatio: 1.6,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 64),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title, style: context.text.headlineSmall),
            const SizedBox(height: 8),
            Text('R\$ ${product.price.toStringAsFixed(2)}', style: context.text.titleLarge),
            const SizedBox(height: 16),
            Text(product.description, style: context.text.bodyMedium),
          ],
        ),
      ),
    );
  }
}
