import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';

enum SearchStatus { loading, loaded, error }

abstract class AutoCompleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AutoCompleteInitial extends AutoCompleteState {}

class SearchLocationState extends AutoCompleteState {
  final SearchStatus status;
  final String? errorMessage;
  final List<SearchAutoCompleteModel>? searchAutocomplete;

  SearchLocationState({
    required this.status,
    this.searchAutocomplete,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, searchAutocomplete];
}

class SearchPlacesState extends AutoCompleteState {
  final SearchStatus status;
  final String? errorMessage;
  final List<GoogleAutoCompleteModel>? searchAutocomplete;

  SearchPlacesState({
    required this.status,
    this.searchAutocomplete,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, searchAutocomplete];
}
