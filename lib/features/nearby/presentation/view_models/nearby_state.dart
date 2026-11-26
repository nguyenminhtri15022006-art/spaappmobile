import '../../models/nearby_spa_item.dart';

enum NearbyLocationStatus {
  granted,
  denied,
  gpsDisabled,
}

class NearbyState {
  final double userLat;
  final double userLng;
  final String userAddress;
  final double selectedRadiusKm;
  final bool isMapView;
  final bool isLoading;
  final NearbyLocationStatus locationStatus;
  final String? errorMessage;
  final List<NearbySpaItem> spas;
  final NearbySpaItem? selectedSpa;

  const NearbyState({
    this.userLat = 10.7769,
    this.userLng = 106.7009,
    this.userAddress = 'Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    this.selectedRadiusKm = 5.0,
    this.isMapView = false,
    this.isLoading = false,
    this.locationStatus = NearbyLocationStatus.granted,
    this.errorMessage,
    this.spas = const [],
    this.selectedSpa,
  });

  bool get hasLocationPermission =>
      locationStatus == NearbyLocationStatus.granted;

  NearbyState copyWith({
    double? userLat,
    double? userLng,
    String? userAddress,
    double? selectedRadiusKm,
    bool? isMapView,
    bool? isLoading,
    NearbyLocationStatus? locationStatus,
    String? errorMessage,
    List<NearbySpaItem>? spas,
    NearbySpaItem? selectedSpa,
    bool clearSelectedSpa = false,
  }) {
    return NearbyState(
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      userAddress: userAddress ?? this.userAddress,
      selectedRadiusKm: selectedRadiusKm ?? this.selectedRadiusKm,
      isMapView: isMapView ?? this.isMapView,
      isLoading: isLoading ?? this.isLoading,
      locationStatus: locationStatus ?? this.locationStatus,
      errorMessage: errorMessage,
      spas: spas ?? this.spas,
      selectedSpa: clearSelectedSpa ? null : (selectedSpa ?? this.selectedSpa),
    );
  }
}
