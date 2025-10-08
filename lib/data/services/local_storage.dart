import 'package:shared_preferences/shared_preferences.dart';

/// Abstrai SharedPreferences para favoritos, flags, etc.
class LocalStorage {
  static const _favoritesKey = 'favorites_ids';

  Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoritesKey) ?? const [];
    return ids.map(int.parse).toList();
  }

  Future<void> saveFavoriteIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      ids.map((e) => e.toString()).toList(),
    );
  }
}
