import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<int, Map<String, dynamic>> _favoritos = {};

  bool isFavorite(int id) => _favoritos.containsKey(id);

  void toggle(int id, Map<String, dynamic> receita) {
    if (_favoritos.containsKey(id)) {
      _favoritos.remove(id);
    } else {
      _favoritos[id] = receita;
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> get items => _favoritos.values.toList();
}
