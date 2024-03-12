import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rateeat_mobile/src/features/filter_restaurants/presentation/bloc/filter_screen/filter_screen_event.dart';
import 'package:rateeat_mobile/src/features/filter_restaurants/presentation/bloc/filter_screen/filter_screen_state.dart';

import '../../../domain/use_cases/use_case.dart';

class FilterBloc extends Bloc<FilterEvent, FilteringState> {
  final FilterRestaurantUseCase filterRestaurantUseCase;
  final GetRatingUseCase getRatingUseCase;
  final GetPriceRangeUseCase getPriceRangeUseCase;
  final GetPriceUseCase getPriceUseCase;
  FilterBloc({
    required this.filterRestaurantUseCase,
    required this.getRatingUseCase,
    required this.getPriceRangeUseCase,
    required this.getPriceUseCase,
  }) : super(FilteringInitial()) {
    on<RatingChangedEvent>(
      (event, emit) async {
        emit(RatingLoading());
        try {
          final response = await getRatingUseCase(
            GetRatingParams(rating: event.rating, location: event.location),
          );
          response.fold(
            (error) {
              emit(
                RatingError(message: "Failed"),
              );
            },
            (result) => emit(
              RatingLoaded(result: result),
            ),
          );
        } catch (e) {
          emit(
            RatingError(
              message: e.toString(),
            ),
          );
        }
      },
    );

    on<PriceChangedEvent>(
      (event, emit) async {
        emit(PriceLoading());
        try {
          final response = await getPriceUseCase(
            GetPriceParams(price: event.price, location: event.location),
          );
          response.fold(
            (error) {
              emit(
                PriceError(message: "Failed"),
              );
            },
            (result) => emit(
              PriceLoaded(result: result),
            ),
          );
        } catch (e) {
          emit(PriceError(message: e.toString()));
        }
      },
    );

    on<PriceRangeChangedEvent>(
      (event, emit) async {
        emit(PriceRangeLoading());
        try {
          final response = await getPriceRangeUseCase(
            GetPriceRangeParams(
                priceRange: event.priceRange, location: event.location),
          );
          response.fold(
            (error) {
              emit(
                PriceRangeError(message: "Failed"),
              );
            },
            (result) => emit(
              PriceRangeLoaded(result: result),
            ),
          );
        } catch (e) {
          emit(PriceRangeError(message: e.toString()));
        }
      },
    );

    on<FilterSubmittedEvent>(
      (event, emit) async {
        emit(FilterLoading());
        try {
          final response = await filterRestaurantUseCase(
            FilterRestaurantParams(
              query: event.query,
            ),
          );
          response.fold(
            (error) {
              emit(
                FilterError(message: "Failed"),
              );
            },
            (results) => emit(
              FilterLoaded(results: results),
            ),
          );
        } catch (e) {
          emit(FilterError(message: e.toString()));
        }
      },
    );
  }
}
