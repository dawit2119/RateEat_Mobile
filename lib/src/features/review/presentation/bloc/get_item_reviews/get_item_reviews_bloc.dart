import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_popularity_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_time_usecase.dart';

part 'get_item_reviews_event.dart';
part 'get_item_reviews_state.dart';

class GetItemReviewsBloc
    extends Bloc<GetItemReviewsEvent, GetItemReviewsState> {
  final GetItemReviewsByPopularityUseCase getItemReviewsByPopularityUseCase;
  final GetItemReviewsByTimeUseCase getItemReviewsByTimeUseCase;

  GetItemReviewsBloc(
      {required this.getItemReviewsByPopularityUseCase,
      required this.getItemReviewsByTimeUseCase})
      : super(const GetItemReviewsInitial(
            sortType: ItemReviewsSortTypesState.mostRecent)) {
    on<GetItemReviewsRequestEvent>(_getItemReviews);
    on<ResetGetItemReviewsEvent>((event, emit) {
      reset(emit);
    });
  }

  Future<void> _getItemReviews(GetItemReviewsRequestEvent event,
      Emitter<GetItemReviewsState> emit) async {
    //* get previous review
    final prevItemReviews = (state is GetItemReviewsLoaded)
        ? (state as GetItemReviewsLoaded).reviews
        : ItemReviewsResponseModel(
            reviews: [],
            ratingsCount: [0, 0, 0, 0, 0],
            averageRating: 0.0,
            numberOfReviews: 0);

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(GetItemReviewsLoading(sortType: state.sortType));
    } else {
      emit(GetItemReviewsNextLoading(
          reviews: prevItemReviews, sortType: state.sortType));
    }

    Either<Failure, ItemReviewsResponse> itemReviews;
    if (event.sortType == ItemReviewsSortTypesState.mostRecent) {
      //* Get the most Recent Reviews
      itemReviews = await getItemReviewsByTimeUseCase(
        GetItemReviewsByTimeParams(
          itemId: event.itemId,
          page: event.page,
          limit: event.limit,
        ),
      );
    } else {
      //* Get the most Popular Reviews
      itemReviews = await getItemReviewsByPopularityUseCase(
        GetItemReviewsByPopularityParams(
          itemId: event.itemId,
          page: event.page,
          limit: event.limit,
        ),
      );
    }

    //* Emit the response
    emit(
      itemReviews.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return GetItemReviewsFailure(
            message: failure.errorMessage,
            sortType: event.sortType,
          );
        }
        //* Second page error message
        return GetItemReviewsLoaded(
          status: false,
          reviews: prevItemReviews,
          sortType: event.sortType,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          final reviews = prevItemReviews.reviews;
          final mergedReviews = List.of(reviews)..addAll(success.reviews);

          return GetItemReviewsLoaded(
            reviews: prevItemReviews.copyWith(reviews: mergedReviews),
            hasReachedMax: success.reviews.isEmpty,
            sortType: event.sortType,
          );
        }
        //* first page Success
        return GetItemReviewsLoaded(
          reviews: success,
          hasReachedMax: false,
          sortType: event.sortType,
        );
      }),
    );
  }

  void reset(Emitter emit) {
    emit(
      const GetItemReviewsInitial(
          sortType: ItemReviewsSortTypesState.mostRecent),
    );
  }
}
