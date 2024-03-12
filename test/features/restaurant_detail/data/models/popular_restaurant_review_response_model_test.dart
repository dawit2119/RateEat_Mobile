import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_review_response.dart';

void main() {
  group('PopularRestaurantReviewResponseModel', () {
    final tPopularRestaurantReviewResponseModel =
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
        firstName: 'Test User',
        image: 'profile.jpg',
        lastName: 'testuser',
        verified: 0,
      ),
      images: ['image1.jpg', 'image2.jpg'],
      videos: ['video1.mp4'],
      voted: 1,
    );

    final tJson = {
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
        'firstName': 'Test User',
        'image': 'profile.jpg',
        'lastName': 'testuser',
        'verified': 0,
      },
      'images': ['image1.jpg', 'image2.jpg'],
      'videos': ['video1.mp4'],
      'voted': 1,
    };

    final tMap = {
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
        'firstName': 'Test User',
        'image': 'profile.jpg',
        'lastName': 'testuser',
        'verified': 0
      },
      'images': ['image1.jpg', 'image2.jpg'],
      'videos': ['video1.mp4'],
      'voted': 1,
    };

    test('should be a subclass of PopularRestaurantReviewResponse entity', () {
      expect(tPopularRestaurantReviewResponseModel,
          isA<PopularRestaurantReviewResponse>());
    });

    test('should return a valid model from json', () {
      // act
      final result = PopularRestaurantReviewResponseModel.fromJson(tJson);
      // assert
      expect(result, equals(tPopularRestaurantReviewResponseModel));
    });

    test('should return a valid model from map', () {
      // act
      final result = PopularRestaurantReviewResponseModel.fromMap(tMap);
      // assert
      expect(result, equals(tPopularRestaurantReviewResponseModel));
    });

    test('should return a json map containing the proper data', () {
      // act
      final result = tPopularRestaurantReviewResponseModel.toJson();
      // assert
      expect(result, equals(tJson));
    });
    test('should return a map containing the proper data', () {
      // act
      final result = tPopularRestaurantReviewResponseModel.toMap();
      // assert
      expect(result, equals(tMap));
    });
    test('fromJson should handle null values correctly', () {
      final jsonWithNulls = {
        'id': '2',
        'rating': null,
        'comment': null,
        'upVote': null,
        'downVote': null,
        'visibility': null,
        'createdAt': null,
        'updatedAt': null,
        'user': null,
        'images': null,
        'videos': null,
        'voted': null,
      };

      final modelWithNulls =
          PopularRestaurantReviewResponseModel.fromJson(jsonWithNulls);

      expect(modelWithNulls.id, '2');
      expect(modelWithNulls.rating, null);
      expect(modelWithNulls.comment, null);
      expect(modelWithNulls.upVote, null);
      expect(modelWithNulls.downVote, null);
      expect(modelWithNulls.visibility, null);
      expect(modelWithNulls.createdAt, null);
      expect(modelWithNulls.updatedAt, null);
      expect(modelWithNulls.user, null);
      expect(modelWithNulls.images, null);
      expect(modelWithNulls.videos, null);
      expect(modelWithNulls.voted, null);
    });

    test('fromMap should handle null values correctly', () {
      final mapWithNulls = {
        'id': '2',
        'rating': null,
        'comment': null,
        'upVote': null,
        'downVote': null,
        'visibility': null,
        'createdAt': null,
        'updatedAt': null,
        'user': null,
        'images': null,
        'videos': null,
        'voted': null,
      };

      final modelWithNulls =
          PopularRestaurantReviewResponseModel.fromMap(mapWithNulls);

      expect(modelWithNulls.id, '2');
      expect(modelWithNulls.rating, null);
      expect(modelWithNulls.comment, null);
      expect(modelWithNulls.upVote, null);
      expect(modelWithNulls.downVote, null);
      expect(modelWithNulls.visibility, null);
      expect(modelWithNulls.createdAt, null);
      expect(modelWithNulls.updatedAt, null);
      expect(modelWithNulls.user, null);
      expect(modelWithNulls.images, null);
      expect(modelWithNulls.videos, null);
      expect(modelWithNulls.voted, null);
    });

    test('toJson should handle null values correctly', () {
      final modelWithNulls = PopularRestaurantReviewResponseModel(
        id: '2',
        rating: null,
        comment: null,
        upVote: null,
        downVote: null,
        visibility: null,
        createdAt: null,
        updatedAt: null,
        user: null,
        images: null,
        videos: null,
        voted: null,
      );
      final json = modelWithNulls.toJson();
      expect(json['id'], '2');
      expect(json['rating'], null);
      expect(json['comment'], null);
      expect(json['upVote'], null);
      expect(json['downVote'], null);
      expect(json['visibility'], null);
      expect(json['createdAt'], null);
      expect(json['updatedAt'], null);
      expect(json['user'], null);
      expect(json['images'], null);
      expect(json['videos'], null);
      expect(json['voted'], null);
    });
    test('toMap should handle null values correctly', () {
      final modelWithNulls = PopularRestaurantReviewResponseModel(
        id: '2',
        rating: null,
        comment: null,
        upVote: null,
        downVote: null,
        visibility: null,
        createdAt: null,
        updatedAt: null,
        user: null,
        images: null,
        videos: null,
        voted: null,
      );
      final map = modelWithNulls.toMap();
      expect(map['id'], '2');
      expect(map['rating'], null);
      expect(map['comment'], null);
      expect(map['upVote'], null);
      expect(map['downVote'], null);
      expect(map['visibility'], null);
      expect(map['createdAt'], null);
      expect(map['updatedAt'], null);
      expect(map['user'], null);
      expect(map['images'], null);
      expect(map['videos'], null);
      expect(map['voted'], null);
    });
  });
}
