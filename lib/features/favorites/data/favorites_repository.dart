import '../../../shared/models/spa.dart';

abstract class FavoritesRepository {
  Future<List<Spa>> getFavoriteSpas();
  Future<bool> isFavorite(String spaId);
  Future<void> addFavorite(String spaId);
  Future<void> removeFavorite(String spaId);
  Future<bool> toggleFavorite(String spaId);
}
