import 'dart:math' as math;
import 'search_repository.dart';
import '../models/spa_search_filter.dart';
import '../models/spa_service_search_result.dart';
import '../../../core/utils/vietnamese_utils.dart';
import '../../../shared/data/mock_spa_data.dart';
import '../../../shared/models/spa.dart';
import '../../../shared/models/spa_branch.dart';
import '../../../shared/models/spa_service.dart';

class MockSearchRepository implements SearchRepository {
  final List<Spa> _spas;

  MockSearchRepository({List<Spa>? spas})
      : _spas = spas ?? MockSpaData.getSpas();

  @override
  Future<List<SpaServiceSearchResult>> search(SpaSearchFilter filter) async {
    // Giả lập độ trễ mạng thực tế của ứng dụng di động (120ms)
    await Future.delayed(const Duration(milliseconds: 120));

    final results = <SpaServiceSearchResult>[];

    final hasLocationFilter = (filter.provinceCode != null && filter.provinceCode!.isNotEmpty);

    for (final spa in _spas) {
      // 1. Kiểm tra đánh giá của Spa
      if (filter.minRating != null && spa.rating < filter.minRating!) {
        continue;
      }

      // 2. Kiểm tra chi nhánh phù hợp điều kiện địa điểm
      final matchingBranches = <SpaBranch>[];
      for (final branch in spa.branches) {
        if (filter.provinceCode != null &&
            filter.provinceCode!.isNotEmpty &&
            branch.provinceCode != filter.provinceCode) {
          continue;
        }
        if (filter.wardCode != null &&
            filter.wardCode!.isNotEmpty &&
            branch.wardCode != filter.wardCode) {
          continue;
        }
        matchingBranches.add(branch);
      }

      // Nếu có lọc địa điểm mà Spa không có chi nhánh nào phù hợp, loại bỏ toàn bộ Spa này
      if (hasLocationFilter && matchingBranches.isEmpty) {
        continue;
      }

      // Nếu không lọc địa điểm, toàn bộ chi nhánh đều được tính
      var effectiveBranches = hasLocationFilter ? matchingBranches : spa.branches;

      // Kiểm tra khoảng cách thực tế so với tọa độ tham chiếu trung tâm (10.7769, 106.7009)
      if (filter.maxDistanceKm != null && filter.maxDistanceKm! > 0) {
        const refLat = 10.7769;
        const refLng = 106.7009;
        effectiveBranches = effectiveBranches.where((b) {
          final dist = _calculateHaversineDistance(refLat, refLng, b.latitude, b.longitude);
          return dist <= filter.maxDistanceKm!;
        }).toList();

        if (effectiveBranches.isEmpty) {
          continue;
        }
      }

      // 3. Lọc danh sách dịch vụ của Spa
      for (final service in spa.services) {
        // Kiểm tra danh mục
        if (filter.categoryId != null &&
            filter.categoryId!.isNotEmpty &&
            service.categoryId != filter.categoryId) {
          continue;
        }

        // Kiểm tra khoảng giá
        if (service.price < filter.minPrice || service.price > filter.maxPrice) {
          continue;
        }

        // Kiểm tra thời lượng
        if (filter.minDuration != null && service.durationMinutes < filter.minDuration!) {
          continue;
        }
        if (filter.maxDuration != null && service.durationMinutes > filter.maxDuration!) {
          continue;
        }

        // Kiểm tra từ khoá (hỗ trợ có dấu và không dấu, không phân biệt hoa thường)
        if (filter.keyword.trim().isNotEmpty) {
          final query = filter.keyword.trim();
          final nameMatch = VietnameseUtils.containsSearch(service.name, query);
          final descMatch = VietnameseUtils.containsSearch(service.description, query);
          final spaNameMatch = VietnameseUtils.containsSearch(spa.name, query);

          // Kiểm tra cả tên chi nhánh hoặc địa chỉ nếu từ khóa liên quan đến vị trí
          final branchMatch = effectiveBranches.any(
            (b) =>
                VietnameseUtils.containsSearch(b.name, query) ||
                VietnameseUtils.containsSearch(b.address, query),
          );

          if (!nameMatch && !descMatch && !spaNameMatch && !branchMatch) {
            continue;
          }
        }

        // Gộp thành một kết quả duy nhất cho dịch vụ của Spa này (không nhân đôi kết quả vì nhiều chi nhánh)
        results.add(
          SpaServiceSearchResult(
            service: service,
            spa: spa,
            matchingBranches: List.unmodifiable(effectiveBranches),
            totalBranchesCount: spa.branches.length,
          ),
        );
      }
    }

    // 4. Sắp xếp kết quả theo sortBy
    _sortResults(results, filter.sortBy, filter.keyword);

    return results;
  }

  void _sortResults(List<SpaServiceSearchResult> list, SortOption sortBy, String keyword) {
    switch (sortBy) {
      case SortOption.priceAsc:
        list.sort((a, b) => a.service.price.compareTo(b.service.price));
        break;
      case SortOption.priceDesc:
        list.sort((a, b) => b.service.price.compareTo(a.service.price));
        break;
      case SortOption.ratingDesc:
        list.sort((a, b) {
          final cmp = b.spa.rating.compareTo(a.spa.rating);
          if (cmp != 0) return cmp;
          return b.spa.reviewCount.compareTo(a.spa.reviewCount);
        });
        break;
      case SortOption.durationAsc:
        list.sort((a, b) => a.service.durationMinutes.compareTo(b.service.durationMinutes));
        break;
      case SortOption.nearest:
        // Sắp xếp theo khoảng cách thực tế nhỏ nhất từ các chi nhánh tới tọa độ tham chiếu trung tâm
        const refLat = 10.7769;
        const refLng = 106.7009;
        list.sort((a, b) {
          final distA = _getMinDistanceKm(a.matchingBranches, refLat, refLng);
          final distB = _getMinDistanceKm(b.matchingBranches, refLat, refLng);
          return distA.compareTo(distB);
        });
        break;
      case SortOption.relevance:
        if (keyword.trim().isNotEmpty) {
          final query = VietnameseUtils.normalize(keyword);
          list.sort((a, b) {
            final aName = VietnameseUtils.normalize(a.service.name);
            final bName = VietnameseUtils.normalize(b.service.name);

            // Ưu tiên trùng tên chính xác hơn
            final aExact = aName == query ? 1 : 0;
            final bExact = bName == query ? 1 : 0;
            if (aExact != bExact) return bExact.compareTo(aExact);

            final aStartsWith = aName.startsWith(query) ? 1 : 0;
            final bStartsWith = bName.startsWith(query) ? 1 : 0;
            if (aStartsWith != bStartsWith) return bStartsWith.compareTo(aStartsWith);

            return b.spa.rating.compareTo(a.spa.rating);
          });
        }
        break;
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      return const [
        'Gội đầu dưỡng sinh',
        'Massage body đá nóng',
        'Làm móng',
        'Chăm sóc da mặt',
        'Trị liệu cổ vai gáy',
      ];
    }

    final suggestions = <String>{};

    // Kiểm tra tên danh mục
    for (final cat in MockSpaData.categories) {
      if (VietnameseUtils.containsSearch(cat.name, clean)) {
        suggestions.add(cat.name);
      }
    }

    // Kiểm tra tên dịch vụ
    for (final spa in _spas) {
      for (final service in spa.services) {
        if (VietnameseUtils.containsSearch(service.name, clean)) {
          suggestions.add(service.name);
        }
      }
    }

    // Kiểm tra tên spa
    for (final spa in _spas) {
      if (VietnameseUtils.containsSearch(spa.name, clean)) {
        suggestions.add(spa.name);
      }
    }

    return suggestions.take(8).toList();
  }

  @override
  Future<Spa?> getSpaById(String spaId) async {
    try {
      return _spas.firstWhere((s) => s.id == spaId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SpaService?> getServiceById(String serviceId) async {
    for (final spa in _spas) {
      for (final service in spa.services) {
        if (service.id == serviceId) return service;
      }
    }
    return null;
  }

  static double _getMinDistanceKm(List<SpaBranch> branches, double refLat, double refLng) {
    if (branches.isEmpty) return double.infinity;
    double minKm = double.infinity;
    for (final b in branches) {
      final km = _calculateHaversineDistance(refLat, refLng, b.latitude, b.longitude);
      if (km < minKm) minKm = km;
    }
    return minKm;
  }

  static double _calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R, R = 6371 km
  }
}
