import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';
import '../core/utils/logger.dart';

/// Controlador de estado com ChangeNotifier (Provider).
/// Expõe lista, loading, erro e ações como toggleFavorite, buscar, etc.
class ProductController extends ChangeNotifier {
  final ProductRepository _repo;

  ProductController(this._repo);

  List<Product> _all = [];
  List<Product> _visible = [];
  String _query = '';
  bool _loading = false;
  String? _error;

  List<Product> get items => _visible;
  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;

  Future<void> loadInitial() async {
    _setLoading(true);
    final res = await _repo.fetchProducts();
    res.when(
      ok: (list) {
        _all = list;
        _applyFilter();
        _error = null;
        logI('ProductController', 'Loaded ${_all.length} products');
      },
      err: (e) {
        _error = 'Falha ao carregar produtos: $e';
      },
    );
    _setLoading(false);
  }

  /// Busca local (client-side) pelo título.
  void search(String q) {
    _query = q;
    _applyFilter();
    notifyListeners();
  }

  void toggleFavorite(Product p) {
    final idx = _all.indexWhere((e) => e.id == p.id);
    if (idx >= 0) {
      _all[idx] = _all[idx].copyWith(favorite: !p.favorite);
      _applyFilter();
      notifyListeners();
      // “fire and forget” – persiste sem bloquear a UI
      _repo.persistFavorites(_all);
    }
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _visible = List.of(_all);
    } else {
      final q = _query.toLowerCase();
      _visible = _all.where((p) => p.title.toLowerCase().contains(q)).toList();
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
