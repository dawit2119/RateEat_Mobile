import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_price_review.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_item_update_repository.dart';

class PriceItemReviewRepoImpl extends ItemPriceReviewRepository {
  final ItemPriceReviewDataSource itemPriceReviewDataSource;
  PriceItemReviewRepoImpl({required this.itemPriceReviewDataSource});
  @override
  Future<Either<Failure, String>> priceReviewRequest(
      {required PriceItemReviewRequestModel
          priceItemReviewRequestModel}) async {
    try {
      final res = await itemPriceReviewDataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: priceItemReviewRequestModel);

      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
