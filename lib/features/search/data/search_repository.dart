import '../models/spa_search_filter.dart';
import '../models/spa_service_search_result.dart';
import '../../../shared/models/spa.dart';
import '../../../shared/models/spa_service.dart';

abstract class SearchRepository {
  Future<List<SpaServiceSearchResult>> search(SpaSearchFilter filter);
  Future<List<String>> getSuggestions(String query);
  Future<Spa?> getSpaById(String spaId);
  Future<SpaService?> getServiceById(String serviceId);
}
