import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class GetItemReviewsByPopularityUseCase
    extends UseCase<ItemReviewsResponse, GetItemReviewsByPopularityParams> {
  final ItemReviewRepository repository;

  GetItemReviewsByPopularityUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, ItemReviewsResponse>> call(
      GetItemReviewsByPopularityParams params) async {
    return await repository.getItemReviewsByPopularity(
      itemId: params.itemId,
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetItemReviewsByPopularityParams extends Equatable {
  final String itemId;
  final int page;
  final int limit;

  const GetItemReviewsByPopularityParams({
    required this.itemId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [itemId, page, limit];
}
