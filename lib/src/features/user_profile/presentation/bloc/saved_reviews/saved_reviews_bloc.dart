import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_saved_reviews_use_case.dart';

part 'saved_reviews_event.dart';
part 'saved_reviews_state.dart';

class SavedReviewsBloc extends Bloc<SavedReviewsEvent, SavedReviewsState> {
  final GetSavedReviewsUseCase getSavedReviewsUseCase;
  SavedReviewsBloc({required this.getSavedReviewsUseCase})
      : super(SavedReviewsInitial()) {
    on<GetSavedReviewsEvent>(_getSavedReviews);
  }

  _getSavedReviews(
      GetSavedReviewsEvent event, Emitter<SavedReviewsState> emit) async {
    try {
      List<SavedReviewsResponse> loadedSavedReviews =
          (state is SavedReviewLoaded &&
                  !(state as SavedReviewLoaded).isLocalData)
              ? (state as SavedReviewLoaded).savedReviews
              : [];

      if (event.page == 1) {
        emit(
          SavedReviewLoading(),
        );
      } else {
        emit(
          SavedNextReviewsLoading(
            savedReviews: loadedSavedReviews,
          ),
        );
      }
      final result = await getSavedReviewsUseCase(
        GetSavedReviewsUseCaseParams(
          page: event.page,
          limit: event.limit,
        ),
      );
      final List<SavedReviewsResponse>? localReviews;
      if (result.isLeft()) {
        localReviews = dpLocator<LocalProfileDataProvider>().getSavedReviews();
        if (localReviews == null) {
          throw Exception("Failed to load saved reviews");
        }
      } else {
        localReviews = [];
      }

      result.fold(
        (error) async {
          if (event.page == 1) {
            try {
              if (localReviews == null) {
                throw Exception("failed to load draft reviews");
              }
              emit(SavedReviewLoaded(
                  savedReviews: localReviews,
                  hasReachedMax: true,
                  isLocalData: true,
                  page: event.page - 1));
            } catch (e) {
              emit(SavedReviewError(error: e.toString()));
            }
          } else {
            emit(
              SavedReviewLoaded(
                savedReviews: loadedSavedReviews,
                status: false,
                isLocalData: false,
                page: event.page - 1,
              ),
            );
          }
        },
        (savedReviews) {
          if (event.page != 1) {
            dpLocator<LocalProfileDataProvider>()
                .cacheSavedReviews(loadedSavedReviews..addAll(savedReviews));
            emit(
              SavedReviewLoaded(
                savedReviews: loadedSavedReviews..addAll(savedReviews),
                hasReachedMax: savedReviews.isEmpty,
                isLocalData: false,
                page: event.page,
              ),
            );
          } else {
            dpLocator<LocalProfileDataProvider>()
                .cacheSavedReviews(savedReviews);
            emit(SavedReviewLoaded(
              savedReviews: savedReviews,
              hasReachedMax: false,
              isLocalData: false,
              page: event.page,
            ));
          }
        },
      );
    } catch (e) {
      emit(SavedReviewError(
          error: e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : e.toString()));
    }
  }
}
