enum SortOption {
  relevance('Liên quan nhất'),
  priceAsc('Giá thấp đến cao'),
  priceDesc('Giá cao đến thấp'),
  ratingDesc('Đánh giá cao nhất'),
  durationAsc('Thời lượng ngắn nhất'),
  nearest('Gần nhất (theo Mốc Demo)');

  final String label;
  const SortOption(this.label);
}

enum DemoLocation {
  none('Chờ GPS thật (Vô hiệu hóa)', null, null),
  benThanh('Mốc Demo: Chợ Bến Thành (TP.HCM)', 10.7721, 106.6983),
  hoanKiem('Mốc Demo: Hồ Hoàn Kiếm (Hà Nội)', 21.0285, 105.8542),
  songHan('Mốc Demo: Cầu Sông Hàn (Đà Nẵng)', 16.0718, 108.2268);

  final String label;
  final double? latitude;
  final double? longitude;

  const DemoLocation(this.label, this.latitude, this.longitude);

  bool get isAvailable => latitude != null && longitude != null;
}

class SpaSearchFilter {
  final String keyword;
  final String? provinceCode;
  final String? wardCode;
  final String? categoryId;
  final double minPrice;
  final double maxPrice;
  final double? minRating;
  final int? minDuration;
  final int? maxDuration;
  final double? maxDistanceKm;
  final DemoLocation demoLocation;
  final SortOption sortBy;

  static const double defaultMinPrice = 0.0;
  static const double defaultMaxPrice = 2000000.0;
  static const double priceStep = 50000.0;

  const SpaSearchFilter({
    this.keyword = '',
    this.provinceCode,
    this.wardCode,
    this.categoryId,
    this.minPrice = defaultMinPrice,
    this.maxPrice = defaultMaxPrice,
    this.minRating,
    this.minDuration,
    this.maxDuration,
    this.maxDistanceKm,
    this.demoLocation = DemoLocation.none,
    this.sortBy = SortOption.relevance,
  });

  SpaSearchFilter copyWith({
    String? keyword,
    String? provinceCode,
    bool clearProvince = false,
    String? wardCode,
    bool clearWard = false,
    String? categoryId,
    bool clearCategory = false,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool clearMinRating = false,
    int? minDuration,
    int? maxDuration,
    bool clearDuration = false,
    double? maxDistanceKm,
    bool clearDistance = false,
    DemoLocation? demoLocation,
    SortOption? sortBy,
  }) {
    final effectiveDemoLocation = demoLocation ?? this.demoLocation;
    return SpaSearchFilter(
      keyword: keyword ?? this.keyword,
      provinceCode: clearProvince ? null : (provinceCode ?? this.provinceCode),
      wardCode: clearWard || clearProvince ? null : (wardCode ?? this.wardCode),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      minDuration: clearDuration ? null : (minDuration ?? this.minDuration),
      maxDuration: clearDuration ? null : (maxDuration ?? this.maxDuration),
      maxDistanceKm: (clearDistance || !effectiveDemoLocation.isAvailable)
          ? null
          : (maxDistanceKm ?? this.maxDistanceKm),
      demoLocation: effectiveDemoLocation,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  /// Số lượng tiêu chí lọc đang được áp dụng (ngoài từ khóa)
  int get activeFilterCount {
    int count = 0;
    if (provinceCode != null && provinceCode!.isNotEmpty) count++;
    if (wardCode != null && wardCode!.isNotEmpty) count++;
    if (categoryId != null && categoryId!.isNotEmpty) count++;
    if (minPrice > defaultMinPrice || maxPrice < defaultMaxPrice) count++;
    if (minRating != null && minRating! > 0) count++;
    if (minDuration != null || maxDuration != null) count++;
    if (demoLocation.isAvailable && maxDistanceKm != null && maxDistanceKm! > 0) {
      count++;
    }
    if (sortBy != SortOption.relevance) count++;
    return count;
  }

  /// Đặt lại toàn bộ bộ lọc nhưng giữ từ khoá
  SpaSearchFilter resetFiltersOnly() {
    return SpaSearchFilter(
      keyword: keyword,
      minPrice: defaultMinPrice,
      maxPrice: defaultMaxPrice,
      demoLocation: DemoLocation.none,
      sortBy: SortOption.relevance,
    );
  }

  /// Đặt lại hoàn toàn cả từ khoá và bộ lọc
  SpaSearchFilter resetAll() {
    return const SpaSearchFilter();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaSearchFilter &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          provinceCode == other.provinceCode &&
          wardCode == other.wardCode &&
          categoryId == other.categoryId &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          minRating == other.minRating &&
          minDuration == other.minDuration &&
          maxDuration == other.maxDuration &&
          maxDistanceKm == other.maxDistanceKm &&
          demoLocation == other.demoLocation &&
          sortBy == other.sortBy;

  @override
  int get hashCode => Object.hash(
        keyword,
        provinceCode,
        wardCode,
        categoryId,
        minPrice,
        maxPrice,
        minRating,
        minDuration,
        maxDuration,
        maxDistanceKm,
        demoLocation,
        sortBy,
      );
}
