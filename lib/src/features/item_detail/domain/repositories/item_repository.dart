import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';

abstract class ItemRepository {
  Future<Either<Failure, Item>> getItem({required String itemId});
  Future<Either<Failure, List<ItemModel>>> getItemRecommendations({
    required String itemId,
  });
  Future<Either<Failure, PopularItemReviewsResponse>> getPopularItemReviews(
      {required String itemId});
}
