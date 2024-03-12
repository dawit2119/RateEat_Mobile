import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_reviews_response_model.dart';

void main() {
  group('ItemReviewsResponseModel', () {
    test('fromJson should return a valid ItemReviewsResponseModel', () {
      // Arrange
      final json = {
        "itemReviews": [
          {
            "id": "review123",
            "rating": 5,
            "comment": "Great product!",
            "upVote": 10,
            "downVote": 2,
            "visibility": true,
            "createdAt": "2023-01-01T00:00:00.000Z",
            "updatedAt": "2023-01-10T00:00:00.000Z",
            "user": {
              "id": "user123",
              "firstName": "John",
              "lastName": "Doe",
              "image": "http://example.com/image.jpg"
            },
            "images": ["http://example.com/image1.jpg"],
            "videos": [
              {"url": "http://example.com/video1.mp4"}
            ],
            "voted": 1
          }
        ],
        "ratingCount": {
          "one_star_count": 1,
          "two_star_count": 2,
          "three_star_count": 3,
          "four_star_count": 4,
          "five_star_count": 5,
        },
        "avgRating": 4.0,
        "numReviews": 10,
      };

      // Act
      final result = ItemReviewsResponseModel.fromJson(json);

      // Assert
      expect(result.reviews.length, 1);
      expect(result.ratingsCount, [1, 2, 3, 4, 5]);
      expect(result.averageRating, 4.0);
      expect(result.numberOfReviews, 10);
      expect(result.reviews[0].id, "review123");
      expect(result.reviews[0].rating, 5.0);
      expect(result.reviews[0].comment, "Great product!");
    });

    test('fromJson should handle empty reviews gracefully', () {
      // Arrange
      final json = {
        "itemReviews": [],
        "ratingCount": null,
        "avgRating": null,
        "numReviews": 0,
      };

      // Act
      final result = ItemReviewsResponseModel.fromJson(json);

      // Assert
      expect(result.reviews.length, 0);
      expect(result.ratingsCount, [0, 0, 0, 0, 0]);
      expect(result.averageRating, 0.0);
      expect(result.numberOfReviews, 0);
    });

    test('getRatingCount should return default values for null input', () {
      // Arrange
      final json = null;

      // Act
      final result = getRatingCount(json ?? <String, dynamic>{});

      // Assert
      expect(result, [0, 0, 0, 0, 0]);
    });
  });
}
