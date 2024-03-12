import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/review/data/models/restaurant_reviews_response_model.dart';

void main() {
  group('RestaurantReviewsResponseModel', () {
    test('fromJson should return a valid RestaurantReviewsResponseModel', () {
      // Arrange
      final json = {
        "restaurantReviews": [
          {
            "id": "review123",
            "rating": 4,
            "comment": "Delicious meal!",
            "upVote": 5,
            "downVote": 1,
            "visibility": true,
            "createdAt": "2023-01-01T00:00:00.000Z",
            "updatedAt": "2023-01-11T00:00:00.000Z",
            "user": {
              "id": "user123",
              "firstName": "Bob",
              "lastName": "Brown",
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
          "one_star_count": 2,
          "two_star_count": 3,
          "three_star_count": 4,
          "four_star_count": 5,
          "five_star_count": 6,
        },
        "avgRating": 4.2,
        "numReviews": 10,
      };

      // Act
      final result = RestaurantReviewsResponseModel.fromJson(json);

      // Assert
      expect(result.reviews.length, 1);
      expect(result.ratingsCount, [2, 3, 4, 5, 6]);
      expect(result.averageRating, 4.2);
      expect(result.numberOfReviews, 10);
      expect(result.reviews[0].id, "review123");
      expect(result.reviews[0].rating, 4.0);
      expect(result.reviews[0].comment, "Delicious meal!");
    });

    test('fromJson should handle empty reviews gracefully', () {
      // Arrange
      final json = {
        "restaurantReviews": [],
        "ratingCount": null,
        "avgRating": null,
        "numReviews": 0,
      };

      // Act
      final result = RestaurantReviewsResponseModel.fromJson(json);

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
      final result = getRatingCount(json);

      // Assert
      expect(result, [0, 0, 0, 0, 0]);
    });
  });
}
