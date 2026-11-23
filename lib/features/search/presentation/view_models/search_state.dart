import '../../models/spa_search_filter.dart';
import '../../models/spa_service_search_result.dart';

enum SearchStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

class SearchState {
  final String query;
  final SpaSearchFilter appliedFilter;
  final SpaSearchFilter draftFilter;
  final SearchStatus status;
  final List<SpaServiceSearchResult> results;
  final List<String> suggestions;
  final String? errorMessage;
  final bool isSuggestionsVisible;

  const SearchState({
    this.query = '',
    this.appliedFilter = const SpaSearchFilter(),
    this.draftFilter = const SpaSearchFilter(),
    this.status = SearchStatus.initial,
    this.results = const [],
    this.suggestions = const [],
    this.errorMessage,
    this.isSuggestionsVisible = false,
  });

  bool get isLoading => status == SearchStatus.loading;
  bool get isSuccess => status == SearchStatus.success;
  bool get isEmpty => status == SearchStatus.empty;
  bool get isError => status == SearchStatus.error;
  bool get isInitial => status == SearchStatus.initial;

  int get totalResultsCount => results.length;

  SearchState copyWith({
    String? query,
    SpaSearchFilter? appliedFilter,
    SpaSearchFilter? draftFilter,
    SearchStatus? status,
    List<SpaServiceSearchResult>? results,
    List<String>? suggestions,
    String? errorMessage,
    bool clearError = false,
    bool? isSuggestionsVisible,
  }) {
    return SearchState(
      query: query ?? this.query,
      appliedFilter: appliedFilter ?? this.appliedFilter,
      draftFilter: draftFilter ?? this.draftFilter,
      status: status ?? this.status,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuggestionsVisible: isSuggestionsVisible ?? this.isSuggestionsVisible,
    );
  }
}
