import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/get_popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_state.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_event.dart';

class PopularSearchesBloc
    extends Bloc<PopularSearchesEvent, PopularSearchesState> {
  final GetPopularSearchesUseCase getPopularSearchesUseCase;

  PopularSearchesBloc({
    required this.getPopularSearchesUseCase,
  }) : super(
          PopularSearchesInitial(),
        ) {
    on<GetPopularSearches>(_onGetPopularSearches);
  }
  void _onGetPopularSearches(
      GetPopularSearches event, Emitter<PopularSearchesState> emit) async {
    try {
      emit(
        PopularSearchActionsLoading(),
      );
      var response = await getPopularSearchesUseCase(
        GetPopularSearchesParams(
          page: event.page,
          limit: event.limit,
        ),
      );
      response.fold(
        (error) => emit(
          PopularSearchActionsFailed(message: "Unable to get popular searches"),
        ),
        (popularSearches) => emit(
          PopularSearchesLoaded(
            popularSearchItems: popularSearches,
          ),
        ),
      );
    } catch (e) {
      emit(
        PopularSearchActionsFailed(message: "Unable to get popular searches"),
      );
    }
  }
}
