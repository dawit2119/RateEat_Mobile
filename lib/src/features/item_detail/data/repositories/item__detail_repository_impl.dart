import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/repositories/item_repository.dart';
import '../../../../core/core.dart';
import '../../../homepage/domain/entities/item.dart';
import '../data_sources/remote_item_detail_datasource.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDataProvider itemDataProvider;
  ItemRepositoryImpl({required this.itemDataProvider});
  @override
  Future<Either<Failure, Item>> getItem({required String itemId}) async {
    try {
      return Right(
        await itemDataProvider.getItem(
          itemId: itemId,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getItemRecommendations(
      {required String itemId}) async {
    try {
      return Right(
          await itemDataProvider.getItemRecommendations(itemId: itemId));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PopularItemReviewsResponse>> getPopularItemReviews(
      {required String itemId}) async {
    try {
      final popularItemReviews =
          await itemDataProvider.getPopularItemsReviews(itemId: itemId);
      return Right(popularItemReviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
