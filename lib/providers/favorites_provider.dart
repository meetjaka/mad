import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier([Set<String>? initial]) : super(initial ?? {}) {
    _init();
  }

  static const _key = 'favorites_v1';

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    state = Set<String>.from(list);
  }

  bool isFavorite(String id) => state.contains(id);

  Future<void> toggle(String id) async {
    final set = Set<String>.from(state);
    if (set.contains(id))
      set.remove(id);
    else
      set.add(id);
    state = set;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.toList());
  }

  Future<void> clearAll() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
    (ref) => FavoritesNotifier());
