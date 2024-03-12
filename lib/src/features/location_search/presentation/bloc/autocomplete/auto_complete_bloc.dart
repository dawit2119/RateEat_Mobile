import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/google_search_places.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

class AutoCompleteBloc extends Bloc<AutoCompleteEvent, AutoCompleteState> {
  final SearchLocationUseCase searchLocationUseCase;
  final GoogleLocationUseCase googleLocationUseCase;

  AutoCompleteBloc(
      {required this.searchLocationUseCase,
      required this.googleLocationUseCase})
      : super(AutoCompleteInitial()) {
    on<SearchLocationEvent>(_onSearchAutoComplete);
    on<GetPlacesEvent>(_onGetPlaces);
    on<TriggerInitialEvent>(onTriggerInitialEvent);
  }

  //Trigger Initial event

  void onTriggerInitialEvent(event, emit) {
    emit(
      AutoCompleteInitial(),
    );
  }

  //* Get the location
  void _onSearchAutoComplete(
      SearchLocationEvent event, Emitter<AutoCompleteState> emit) async {
    emit(SearchLocationState(status: SearchStatus.loading));

    final failureOrSuggestion =
        await searchLocationUseCase(SearchLocationParams(place: event.place));

    emit(_eitherSuggestionOrError(failureOrSuggestion));
  }

  AutoCompleteState _eitherSuggestionOrError(
      Either<Failure, List<SearchAutoCompleteModel>> failureOrSuggestion) {
    return failureOrSuggestion.fold(
      (error) => SearchLocationState(
          status: SearchStatus.error, errorMessage: "Error"),
      (suggestion) => SearchLocationState(
          status: SearchStatus.loaded, searchAutocomplete: suggestion),
    );
  }

  //* Google Api Get Places
  void _onGetPlaces(
      GetPlacesEvent event, Emitter<AutoCompleteState> emit) async {
    emit(SearchPlacesState(status: SearchStatus.loading));

    final failureOrPlaces =
        await googleLocationUseCase(SearchLocationParams(place: event.place));

    emit(_eitherPlacesOrError(failureOrPlaces));
  }

  AutoCompleteState _eitherPlacesOrError(
      Either<Failure, List<GoogleAutoCompleteModel>> failureOrSuggestion) {
    return failureOrSuggestion.fold(
      (error) =>
          SearchPlacesState(status: SearchStatus.error, errorMessage: "Error"),
      (prediction) => SearchPlacesState(
          status: SearchStatus.loaded, searchAutocomplete: prediction),
    );
  }
}
