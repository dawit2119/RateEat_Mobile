import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

import '../../domain/entities/flag_review.dart';
import '../../domain/entities/item_reviews_response.dart';

class ItemReviewRepositoryImpl extends ItemReviewRepository {
  final ItemReviewDataSource itemReviewSource;
  ItemReviewRepositoryImpl({required this.itemReviewSource});

  @override
  Future<Either<Failure, bool>> addItemReview({
    required AddItemReviewRequestModel addItemReviewRequestModel,
    required bool isCandidateItem,
  }) async {
    try {
      final response = await itemReviewSource.addItemReview(
        addItemReviewRequestModel: addItemReviewRequestModel,
        isCandidateItem: isCandidateItem,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> editItemReview(
      {required EditItemReviewRequestModel editItemReviewRequestModel}) async {
    try {
      final response = await itemReviewSource.editItemReview(
          editItemReviewRequestModel: editItemReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteItemReview(
      {required DeleteItemReviewRequestModel
          deleteItemReviewRequestModel}) async {
    try {
      final response = await itemReviewSource.deleteItemReview(
          deleteItemReviewRequestModel: deleteItemReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> flagReview(
      {required FlagReview review}) async {
    try {
      final response = await itemReviewSource.flagReview(
        review: review,
      );
      return Right(
        response,
      );
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemReviewsResponse>> getItemReviewsByPopularity(
      {required itemId, required int limit, required int page}) async {
    try {
      final itemReviews = await itemReviewSource.getItemReviewsByPopularity(
          itemId: itemId, limit: limit, page: page);
      return Right(itemReviews);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ItemReviewsResponse>> getItemReviewsByTime(
      {required itemId, required int limit, required int page}) async {
    try {
      final itemReviews = await itemReviewSource.getItemReviewsByTime(
          itemId: itemId, limit: limit, page: page);
      return Right(itemReviews);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addDraftToReview(
      {required DraftToReviewRequestModel draftToReviewRequestModel}) async {
    try {
      final response = await itemReviewSource.addDraftToReview(
          draftToReviewRequestModel: draftToReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteDraftItemReview(
      {required DeleteDraftItemReviewRequestModel
          deleteDraftItemReviewRequestModel}) async {
    try {
      final response = await itemReviewSource.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel: deleteDraftItemReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
