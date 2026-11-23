import 'package:flutter_test/flutter_test.dart';
import 'package:spa_marketplace/features/favorites/data/mock_favorites_repository.dart';
import 'package:spa_marketplace/features/favorites/presentation/view_models/favorites_view_model.dart';

void main() {
  late MockFavoritesRepository repo;
  late FavoritesViewModel viewModel;

  setUp(() {
    repo = MockFavoritesRepository();
    viewModel = FavoritesViewModel(repo);
  });

  group('FavoritesViewModel Tests', () {
    test('Tải danh sách yêu thích ban đầu', () async {
      await viewModel.loadFavorites();
      expect(viewModel.state.favoriteSpas.isNotEmpty, isTrue);
      expect(viewModel.state.isFavorite('spa_lotus'), isTrue);
    });

    test('Chuyển đổi trạng thái yêu thích (Toggle Favorite)', () async {
      await viewModel.loadFavorites();
      const testSpaId = 'spa_green';

      // Ban đầu chưa thích spa_green
      expect(viewModel.state.isFavorite(testSpaId), isFalse);

      // Bấm thích
      final isNowFav = await viewModel.toggleFavorite(testSpaId);
      expect(isNowFav, isTrue);
      expect(viewModel.state.isFavorite(testSpaId), isTrue);

      // Bấm bỏ thích
      final isUnfav = await viewModel.toggleFavorite(testSpaId);
      expect(isUnfav, isFalse);
      expect(viewModel.state.isFavorite(testSpaId), isFalse);
    });
  });
}
