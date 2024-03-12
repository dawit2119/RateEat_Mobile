import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/models/vote_response_model.dart';

import '../../domain/entities/vote_on_review.dart';

class VoteOnReviewDataProvider {
  final Dio dio;

  VoteOnReviewDataProvider({required this.dio});

  Future<Either<Failure, VoteResponse>> upVoteItemReview({
    required String userId,
    required String reviewId,
  }) async {
    try {
      final response = await dio.post(
        "$baseURL/votes/upvote-item-review",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "userId": userId,
          "reviewId": reviewId,
        },
      );
      if (response.statusCode == 201) {
        var voteResponseData = response.data;
        var voteResponse = VoteResponseModel.fromMap(voteResponseData);
        return right(voteResponse);
      } else if (response.statusCode.toString().startsWith('5')) {
        return left(ServerFailure());
      } else {
        return left(NetworkFailure());
      }
    } catch (e) {
      return left(ServerFailure());
    }
  }

  Future<Either<Failure, VoteResponse>> downVoteItemReview({
    required String userId,
    required String reviewId,
  }) async {
    try {
      final response = await dio.post(
        "$baseURL/votes/downvote-item-review",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "userId": userId,
          "reviewId": reviewId,
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 201) {
        var voteResponseData = response.data;
        var voteResponse = VoteResponseModel.fromMap(voteResponseData);
        return right(voteResponse);
      } else if (response.statusCode.toString().startsWith('5')) {
        return left(ServerFailure());
      } else {
        return left(NetworkFailure());
      }
    } catch (e) {
      return left(ServerFailure());
    }
  }

  Future<Either<Failure, VoteResponse>> upVoteRestaurantReview({
    required String userId,
    required String reviewId,
  }) async {
    try {
      final response = await dio.post(
        "$baseURL/votes/upvote-restaurant-review",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "userId": userId,
          "reviewId": reviewId,
        },
      );
      if (response.statusCode == 201) {
        var voteResponseData = response.data;
        var voteResponse = VoteResponseModel.fromMap(voteResponseData);
        return right(voteResponse);
      } else if (response.statusCode.toString().startsWith('5')) {
        return left(ServerFailure());
      } else {
        return left(NetworkFailure());
      }
    } catch (e) {
      return left(ServerFailure());
    }
  }

  Future<Either<Failure, VoteResponse>> downVoteRestaurantReview({
    required String userId,
    required String reviewId,
  }) async {
    try {
      final response = await dio.post(
        "$baseURL/votes/downvote-restaurant-review",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "userId": userId,
          "reviewId": reviewId,
        },
      );
      if (response.statusCode == 201) {
        var voteResponseData = response.data;
        var voteResponse = VoteResponseModel.fromMap(voteResponseData);
        return right(voteResponse);
      } else if (response.statusCode.toString().startsWith('5')) {
        return left(ServerFailure());
      } else {
        return left(NetworkFailure());
      }
    } catch (e) {
      return left(ServerFailure());
    }
  }
}
