import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/favorites_repository.dart';
import '../../data/mock_favorites_repository.dart';
import '../../../shared/models/spa.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return MockFavoritesRepository();
});

class FavoritesState {
  final List<Spa> favoriteSpas;
  final Set<String> favoriteIds;
  final bool isLoading;

  const FavoritesState({
    this.favoriteSpas = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
  });

  bool isFavorite(String spaId) => favoriteIds.contains(spaId);

  FavoritesState copyWith({
    List<Spa>? favoriteSpas,
    Set<String>? favoriteIds,
    bool? isLoading,
  }) {
    return FavoritesState(
      favoriteSpas: favoriteSpas ?? this.favoriteSpas,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final favoritesViewModelProvider =
    StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesViewModel(repo);
});

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesViewModel(this._repository) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);
    final spas = await _repository.getFavoriteSpas();
    state = state.copyWith(
      favoriteSpas: spas,
      favoriteIds: spas.map((s) => s.id).toSet(),
      isLoading: false,
    );
  }

  Future<bool> toggleFavorite(String spaId) async {
    final isFav = await _repository.toggleFavorite(spaId);
    await loadFavorites();
    return isFav;
  }
}
