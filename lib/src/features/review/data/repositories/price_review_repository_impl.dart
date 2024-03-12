import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_price_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_update_repository.dart';

class PriceReviewRepoImpl extends PriceReviewRepository {
  final PriceReviewDataSource priceReviewDataSource;

  PriceReviewRepoImpl({required this.priceReviewDataSource});

  @override
  Future<Either<Failure, String>> priceReviewRequest(
      {required PriceReviewRequestModel priceReviewRequestModel}) async {
    try {
      final res = await priceReviewDataSource.priceReviewRequest(
          priceReviewRequestModel: priceReviewRequestModel);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
