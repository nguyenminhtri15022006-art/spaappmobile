enum SortOption {
  relevance('Liên quan nhất'),
  priceAsc('Giá thấp đến cao'),
  priceDesc('Giá cao đến thấp'),
  ratingDesc('Đánh giá cao nhất'),
  durationAsc('Thời lượng ngắn nhất'),
  nearest('Gần nhất (Demo)');

  final String label;
  const SortOption(this.label);
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
    SortOption? sortBy,
  }) {
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
      maxDistanceKm: clearDistance ? null : (maxDistanceKm ?? this.maxDistanceKm),
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
    if (maxDistanceKm != null && maxDistanceKm! > 0) count++;
    if (sortBy != SortOption.relevance) count++;
    return count;
  }

  /// Đặt lại toàn bộ bộ lọc nhưng giữ từ khoá
  SpaSearchFilter resetFiltersOnly() {
    return SpaSearchFilter(
      keyword: keyword,
      minPrice: defaultMinPrice,
      maxPrice: defaultMaxPrice,
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
        sortBy,
      );
}
