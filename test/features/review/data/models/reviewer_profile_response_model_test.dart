import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/review/data/models/reviewer_profile_response_model.dart';

void main() {
  group('ReviewerProfileResponseModel', () {
    test('fromJson should return a valid ReviewerProfileResponseModel', () {
      // Arrange
      final json = {
        "id": "user123",
        "firstName": "Jane",
        "lastName": "Doe",
        "image": "http://example.com/image.jpg",
        "verified": 1
      };

      // Act
      final result = ReviewerProfileResponseModel.fromJson(json);

      // Assert
      expect(result.id, "user123");
      expect(result.firstName, "Jane");
      expect(result.lastName, "Doe");
      expect(result.image, "http://example.com/image.jpg");
      expect(result.verified, 1);
    });

    test('fromJson should handle missing fields gracefully', () {
      // Arrange
      final json = {
        "id": "user123",
        "firstName": null,
        "lastName": null,
        "image": null,
        // 'verified' is missing
      };

      // Act
      final result = ReviewerProfileResponseModel.fromJson(json);

      // Assert
      expect(result.id, "user123");
      expect(result.firstName, ""); // Default value
      expect(result.lastName, ""); // Default value
      expect(result.image, ""); // Default value
      expect(result.verified, 0);
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      final reviewerProfile = ReviewerProfileResponseModel(
        id: "user123",
        firstName: "Jane",
        lastName: "Doe",
        image: "http://example.com/image.jpg",
        verified: 1,
      );

      // Act
      final result = reviewerProfile.toJson();

      // Assert
      expect(result, {
        "id": "user123",
        "firstName": "Jane",
        "lastName": "Doe",
        "image": "http://example.com/image.jpg",
      });
    });
  });
}
