import '../../core/utils/result.dart';
import '../models/product.dart';
import '../services/api_client.dart';
import '../services/local_storage.dart';

/// Orquestra fontes (remota/local) e expõe métodos de domínio.
/// A UI/Controller fala só com o repositório.
class ProductRepository {
  final ApiClient _api;
  final LocalStorage _storage;

  ProductRepository(this._api, this._storage);

  /// Busca produtos da API fake + marca favoritos salvos localmente.
  Future<Result<List<Product>>> fetchProducts() async {
    final res = await _api.get('/products'); // ex.: https://fakestoreapi.com/products
    return res.when(
      ok: (data) async {
        final list = Product.listFromJson(data);
        final favIds = await _storage.getFavoriteIds();
        final merged = list
            .map((p) => p.copyWith(favorite: favIds.contains(p.id)))
            .toList();
        return Ok(merged);
      },
      err: (e) => Err(e),
    );
  }

  /// Persiste favoritos.
  Future<void> persistFavorites(List<Product> products) async {
    final ids = products.where((p) => p.favorite).map((p) => p.id).toList();
    await _storage.saveFavoriteIds(ids);
  }
}
