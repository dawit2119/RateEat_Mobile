import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

class GetPopularItemReviewsUseCase
    extends UseCase<PopularItemReviewsResponse, GetItemsPopularReviewsParams> {
  final ItemRepository reviewRepository;
  GetPopularItemReviewsUseCase({required this.reviewRepository});

  @override
  Future<Either<Failure, PopularItemReviewsResponse>> call(
      GetItemsPopularReviewsParams params) async {
    return await reviewRepository.getPopularItemReviews(
      itemId: params.itemId,
    );
  }
}

class GetItemsPopularReviewsParams extends Equatable {
  final String itemId;

  const GetItemsPopularReviewsParams({
    required this.itemId,
  });

  @override
  List<Object> get props => [itemId];
}
