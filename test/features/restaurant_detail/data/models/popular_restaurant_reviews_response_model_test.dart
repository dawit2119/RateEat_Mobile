import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';

void main() {
  group('PopularRestaurantReviewsResponseModel', () {
    final tPopularRestaurantReviewsResponseModel =
        PopularRestaurantReviewsResponseModel(
      reviews: [
        PopularRestaurantReviewResponseModel(
          id: '1',
          rating: 4.5,
          comment: 'Test comment',
          upVote: 10,
          downVote: 2,
          visibility: true,
          createdAt: DateTime(2023, 10, 26),
          updatedAt: DateTime(2023, 10, 27),
          user: PopularRestaurantReviewerProfileResponseModel(
            id: 'user1',
            firstName: 'Test',
            lastName: 'User',
            image: 'profile.jpg',
            verified: 1,
          ),
          images: ['image1.jpg', 'image2.jpg'],
          videos: ['video1.mp4'],
          voted: 1,
        ),
      ],
      ratingsCount: [1, 2, 3, 4, 5],
      averageRating: 4.0,
      numberOfReviews: 1,
    );

    final tJson = {
      'restaurantReviews': [
        {
          'id': '1',
          'rating': 4.5,
          'comment': 'Test comment',
          'upVote': 10,
          'downVote': 2,
          'visibility': true,
          'createdAt': '2023-10-26T00:00:00.000',
          'updatedAt': '2023-10-27T00:00:00.000',
          'user': {
            'id': 'user1',
            'firstName': 'Test',
            'lastName': 'User',
            'image': 'profile.jpg',
            'verified': 1,
          },
          'images': ['image1.jpg', 'image2.jpg'],
          'videos': ['video1.mp4'],
          'voted': 1,
        },
      ],
      'ratingCount': {
        'one_star_count': 1,
        'two_star_count': 2,
        'three_star_count': 3,
        'four_star_count': 4,
        'five_star_count': 5,
      },
      'avgRating': 4.0,
      'numReviews': 1,
    };

    test('should be a subclass of PopularRestaurantReviewsResponse entity', () {
      expect(tPopularRestaurantReviewsResponseModel,
          isA<PopularRestaurantReviewsResponse>());
    });

    test('should return a valid model from json', () {
      // act
      final result = PopularRestaurantReviewsResponseModel.fromJson(tJson);
      // assert
      expect(result.reviews.length, 1);
      expect(result.reviews[0].id, '1');
      expect(result.reviews[0].rating, 4.5);
      expect(result.reviews[0].comment, 'Test comment');
      expect(result.ratingsCount, [1, 2, 3, 4, 5]);
      expect(result.averageRating, 4.0);
      expect(result.numberOfReviews, 1);
    });
    test('fromJson should handle null values correctly', () {
      final jsonWithNulls = {
        'restaurantReviews': [],
        'ratingCount': {
          'one_star_count': null,
          'two_star_count': null,
          'three_star_count': null,
          'four_star_count': null,
          'five_star_count': null,
        },
        'avgRating': null,
        'numReviews': null,
      };

      final modelWithNulls =
          PopularRestaurantReviewsResponseModel.fromJson(jsonWithNulls);

      expect(modelWithNulls.reviews, isEmpty);
      expect(modelWithNulls.ratingsCount, [0, 0, 0, 0, 0]);
      expect(modelWithNulls.averageRating, 0.0);
      expect(modelWithNulls.numberOfReviews, 0);
    });

    test('should return a json map containing the proper data', () {
      // act
      final result = tPopularRestaurantReviewsResponseModel.toJson();
      // assert
      expect(result, equals(tJson));
    });

    test('toJson should handle null values correctly', () {
      final modelWithNulls = PopularRestaurantReviewsResponseModel(
        reviews: [],
        ratingsCount: [0, 0, 0, 0, 0],
        averageRating: 0.0,
        numberOfReviews: 0,
      );
      final json = modelWithNulls.toJson();
      expect(json['restaurantReviews'], []);
      expect(json['ratingCount'], {
        'one_star_count': 0,
        'two_star_count': 0,
        'three_star_count': 0,
        'four_star_count': 0,
        'five_star_count': 0
      });
      expect(json['avgRating'], 0.0);
      expect(json['numReviews'], 0);
    });
    test('should return a valid model when average rating is a string', () {
      final jsonWithStringAvgRating = {
        'restaurantReviews': [],
        'ratingCount': {
          'one_star_count': 1,
          'two_star_count': 2,
          'three_star_count': 3,
          'four_star_count': 4,
          'five_star_count': 5,
        },
        'avgRating': 4.5,
        'numReviews': 1,
      };
      // act
      final result = PopularRestaurantReviewsResponseModel.fromJson(
          jsonWithStringAvgRating);
      // assert
      expect(result.averageRating, 4.5);
    });
    test('should return a valid model when average rating is null', () {
      final jsonWithStringAvgRating = {
        'restaurantReviews': [],
        'ratingCount': {
          'one_star_count': 1,
          'two_star_count': 2,
          'three_star_count': 3,
          'four_star_count': 4,
          'five_star_count': 5,
        },
        'avgRating': null,
        'numReviews': 1,
      };
      // act
      final result = PopularRestaurantReviewsResponseModel.fromJson(
          jsonWithStringAvgRating);
      // assert
      expect(result.averageRating, 0.0);
    });
  });
}
