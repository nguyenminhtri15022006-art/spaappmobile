import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/nearby_spa_item.dart';
import '../../repositories/nearby_repository.dart';
import 'nearby_state.dart';

final nearbyRepositoryProvider = Provider<NearbyRepository>((ref) {
  return MockNearbyRepository();
});

final nearbyViewModelProvider =
    StateNotifierProvider<NearbyViewModel, NearbyState>((ref) {
  final repository = ref.watch(nearbyRepositoryProvider);
  return NearbyViewModel(repository);
});

class NearbyViewModel extends StateNotifier<NearbyState> {
  final NearbyRepository _repository;

  NearbyViewModel(this._repository) : super(const NearbyState()) {
    fetchNearbySpas();
  }

  Future<void> fetchNearbySpas() async {
    if (state.locationStatus != NearbyLocationStatus.granted) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await _repository.getNearbySpas(
        latitude: state.userLat,
        longitude: state.userLng,
        radiusKm: state.selectedRadiusKm,
      );
      state = state.copyWith(
        isLoading: false,
        spas: items,
        selectedSpa: items.isNotEmpty ? items.first : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải danh sách Spa gần bạn. Vui lòng thử lại.',
      );
    }
  }

  void setRadius(double radiusKm) {
    if (state.selectedRadiusKm == radiusKm) return;
    state = state.copyWith(selectedRadiusKm: radiusKm);
    fetchNearbySpas();
  }

  void toggleViewMode() {
    state = state.copyWith(isMapView: !state.isMapView);
  }

  void selectSpa(NearbySpaItem? item) {
    state = state.copyWith(selectedSpa: item);
  }

  void grantPermission() {
    state = state.copyWith(locationStatus: NearbyLocationStatus.granted);
    fetchNearbySpas();
  }

  void simulatePermissionDenied() {
    state = state.copyWith(
      locationStatus: NearbyLocationStatus.denied,
      spas: [],
    );
  }

  void simulateGpsDisabled() {
    state = state.copyWith(
      locationStatus: NearbyLocationStatus.gpsDisabled,
      spas: [],
    );
  }

  void refreshLocation({
    double? lat,
    double? lng,
    String? address,
  }) {
    state = state.copyWith(
      userLat: lat ?? state.userLat,
      userLng: lng ?? state.userLng,
      userAddress: address ?? state.userAddress,
      locationStatus: NearbyLocationStatus.granted,
    );
    fetchNearbySpas();
  }
}
