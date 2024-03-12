import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class GetItemReviewsByTimeUseCase
    extends UseCase<ItemReviewsResponse, GetItemReviewsByTimeParams> {
  final ItemReviewRepository repository;

  GetItemReviewsByTimeUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, ItemReviewsResponse>> call(
      GetItemReviewsByTimeParams params) async {
    return await repository.getItemReviewsByTime(
      itemId: params.itemId,
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetItemReviewsByTimeParams extends Equatable {
  final String itemId;
  final int page;
  final int limit;

  const GetItemReviewsByTimeParams({
    required this.itemId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [itemId, page, limit];
}
