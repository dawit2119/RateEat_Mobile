import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_review_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviews_response_model.dart';

import 'popular_item_reviews_response_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationLocalSource>(),
])
void main() {
  group('PopularItemReviewsResponseModel', () {
    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    setUp(() async {
      await dpLocator.reset();
      mockAuthenticationLocalSource = MockAuthenticationLocalSource();
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => mockAuthenticationLocalSource);
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(LocalUserModel(token: "mock token"));
    });
    test('creates an instance correctly', () {
      final reviews = [
        PopularItemReviewResponseModel(
          id: 'review1',
          rating: 4.5,
          comment: 'Great item!',
          upVote: 5,
          downVote: 1,
          visibility: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          user: null,
          images: [],
          videos: [],
          voted: 1,
        ),
      ];

      final model = PopularItemReviewsResponseModel(
        ratingsCount: [1, 2, 3, 4, 5],
        reviews: reviews,
        averageRating: 4.5,
        numberOfReviews: 10,
      );

      expect(model.ratingsCount, [1, 2, 3, 4, 5]);
      expect(model.reviews, reviews);
      expect(model.averageRating, 4.5);
      expect(model.numberOfReviews, 10);
    });

    test('fromJson creates an instance from JSON', () {
      final json = {
        "itemReviews": [
          {
            "id": "review1",
            "rating": 4.5,
            "comment": "Great item!",
            "upVote": 5,
            "downVote": 1,
            "visibility": true,
            "createdAt": "2023-01-01T00:00:00.000Z",
            "updatedAt": "2023-01-02T00:00:00.000Z",
            "user": null,
            "images": [],
            "videos": [],
            "voted": 1,
          },
        ],
        "ratingCount": {
          "one_star_count": 1,
          "two_star_count": 2,
          "three_star_count": 3,
          "four_star_count": 4,
          "five_star_count": 5,
        },
        "avgRating": 4.5,
        "numReviews": 10,
      };

      final model = PopularItemReviewsResponseModel.fromJson(json);

      expect(model.reviews.length, 1);
      expect(model.reviews[0].id, 'review1');
      expect(model.ratingsCount, [1, 2, 3, 4, 5]);
      expect(model.averageRating, 4.5);
      expect(model.numberOfReviews, 10);
    });

    test('fromJson handles missing fields gracefully', () {
      final json = {
        "itemReviews": [],
        "ratingCount": <String, dynamic>{},
        "avgRating": null,
        "numReviews": null,
      };

      final model = PopularItemReviewsResponseModel.fromJson(json);

      expect(model.reviews.length, 0);
      expect(model.ratingsCount, [0, 0, 0, 0, 0]);
      expect(model.averageRating, 0.0);
      expect(model.numberOfReviews, 0);
    });

    test('getRatingCount returns correct counts', () {
      final ratingJson = {
        "one_star_count": 1,
        "two_star_count": 2,
        "three_star_count": 3,
        "four_star_count": 4,
        "five_star_count": 5,
      };

      final counts = getRatingCount(ratingJson);

      expect(counts, [1, 2, 3, 4, 5]);
    });

    test('getRatingCount handles missing fields', () {
      final Map<String, dynamic> ratingJson = {
        // Fields intentionally left out
      };

      final counts = getRatingCount(ratingJson);

      expect(counts, [0, 0, 0, 0, 0]);
    });
  });
}
