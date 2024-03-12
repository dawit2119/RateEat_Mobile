import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/usecases/get_popular_item_reviews_use_case.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_event.dart';

class PopularItemReviewsBloc
    extends Bloc<PopularItemReviewsEvent, PopularItemReviewsState> {
  final GetPopularItemReviewsUseCase getPopularItemReviewsUseCase;
  PopularItemReviewsBloc({required this.getPopularItemReviewsUseCase})
      : super(PopularItemReviewsInitial()) {
    on<GetPopularItemReviewsEvent>(_onPopularItemReviews);
  }

  //* Get item popular reviews
  void _onPopularItemReviews(GetPopularItemReviewsEvent event,
      Emitter<PopularItemReviewsState> emit) async {
    emit(PopularItemReviewLoading());
    try {
      final failureOrPopular = await getPopularItemReviewsUseCase(
        GetItemsPopularReviewsParams(itemId: event.itemId),
      );
      final PopularItemReviewsResponse? localReviews;
      if (failureOrPopular.isLeft()) {
        localReviews = await dpLocator<LocalItemDetailDataSource>()
            .getPopularItemReviews(event.itemId);
      } else {
        localReviews = null;
        await failureOrPopular.fold(
          (l) => null,
          (r) => dpLocator<LocalItemDetailDataSource>()
              .savePopularItemReviews(event.itemId, r),
        );
      }
      if (failureOrPopular.isRight()) {
        emit(_eitherPopularOrFailure(failureOrPopular));
      }
      if (localReviews != null) {
        emit(PopularItemReviewsLoaded(
            popularReviews: localReviews, isLocal: true));
      }
    } catch (e) {
      emit(PopularItemReviewsFailure(message: e.toString()));
    }
  }

  PopularItemReviewsState _eitherPopularOrFailure(
      Either<Failure, PopularItemReviewsResponse> failureOrPopular) {
    return failureOrPopular.fold(
      (error) => PopularItemReviewsFailure(message: error.errorMessage),
      (success) =>
          PopularItemReviewsLoaded(popularReviews: success, isLocal: false),
    );
  }
}
