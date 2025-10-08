import 'package:flutter/material.dart';
import '../../data/models/product.dart';

/// Card reutilizável para exibir um produto em listas.
/// Regras visuais padronizadas ficam aqui.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Imagem
            SizedBox(
              width: 96,
              height: 96,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),
            // Texto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text('R\$ ${product.price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onToggleFavorite,
              icon: Icon(product.favorite ? Icons.favorite : Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }
}
