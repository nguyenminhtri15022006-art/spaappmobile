import '../../../shared/models/spa.dart';
import '../../../shared/models/spa_branch.dart';
import '../../../shared/models/spa_service.dart';

class SpaServiceSearchResult {
  final SpaService service;
  final Spa spa;
  final List<SpaBranch> matchingBranches;
  final int totalBranchesCount;

  const SpaServiceSearchResult({
    required this.service,
    required this.spa,
    required this.matchingBranches,
    required this.totalBranchesCount,
  });

  /// Tên chi nhánh đầu tiên hoặc tóm tắt địa điểm
  String get primaryLocationSummary {
    if (matchingBranches.isEmpty) {
      return spa.branches.isNotEmpty
          ? spa.branches.first.address
          : 'Toàn hệ thống';
    }
    return matchingBranches.first.address;
  }

  /// Số lượng chi nhánh phù hợp
  int get matchingBranchesCount => matchingBranches.length;

  /// Có nhiều chi nhánh phù hợp hay không
  bool get hasMultipleMatchingBranches => matchingBranches.length > 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaServiceSearchResult &&
          runtimeType == other.runtimeType &&
          service.id == other.service.id &&
          spa.id == other.spa.id;

  @override
  int get hashCode => Object.hash(service.id, spa.id);
}
