import 'favorites_repository.dart';
import '../../../shared/data/mock_spa_data.dart';
import '../../../shared/models/spa.dart';

class MockFavoritesRepository implements FavoritesRepository {
  final Set<String> _favoriteIds = {'spa_lotus', 'spa_annam'};

  @override
  Future<List<Spa>> getFavoriteSpas() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final allSpas = MockSpaData.getSpas();
    return allSpas.where((s) => _favoriteIds.contains(s.id)).toList();
  }

  @override
  Future<bool> isFavorite(String spaId) async {
    return _favoriteIds.contains(spaId);
  }

  @override
  Future<void> addFavorite(String spaId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _favoriteIds.add(spaId);
  }

  @override
  Future<void> removeFavorite(String spaId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _favoriteIds.remove(spaId);
  }

  @override
  Future<bool> toggleFavorite(String spaId) async {
    if (_favoriteIds.contains(spaId)) {
      await removeFavorite(spaId);
      return false;
    } else {
      await addFavorite(spaId);
      return true;
    }
  }
}
