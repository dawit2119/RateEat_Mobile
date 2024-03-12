import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_review_reponse_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/reviewer_profile_response_model.dart';

import 'item_review_response_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationLocalSource>(),
])
void main() {
  MockAuthenticationLocalSource mockAuthenticationLocalSource;

  setUp(() async {
    await dpLocator.reset();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerCachedFactory<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
    when(mockAuthenticationLocalSource.getUserCredential())
        .thenAnswer((_) => LocalUserModel());
  });

  group('ItemReviewResponseModel', () {
    test('fromJson should return a valid ItemReviewResponseModel', () {
      // Arrange
      final json = {
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
      };

      // Act
      final result = ItemReviewResponseModel.fromJson(json);

      // Assert
      expect(result.id, "review123");
      expect(result.rating, 5.0);
      expect(result.comment, "Great product!");
      expect(result.upVote, 10);
      expect(result.downVote, 2);
      expect(result.visibility, true);
      expect(result.createdAt, DateTime.parse("2023-01-01T00:00:00.000Z"));
      expect(result.updatedAt, DateTime.parse("2023-01-10T00:00:00.000Z"));
      expect(result.user, isA<ReviewerProfileResponseModel>());
      expect(result.images, ["http://example.com/image1.jpg"]);
      expect(result.videos, ["http://example.com/video1.mp4"]);
      expect(result.voted, 1);
    });

    test('fromJson should handle missing fields gracefully', () {
      // Arrange
      final json = {
        "id": "review123",
        "rating": null,
        "comment": null,
        "upVote": null,
        "downVote": null,
        "visibility": null,
        "createdAt": null,
        "updatedAt": null,
        "user": null,
        "images": [],
        "videos": [],
        "voted": null
      };

      // Act
      final result = ItemReviewResponseModel.fromJson(json);

      // Assert
      expect(result.id, "review123");
      expect(result.rating, 0.0); // Default value
      expect(result.comment, ""); // Default value
      expect(result.upVote, 0); // Default value
      expect(result.downVote, 0); // Default value
      expect(result.visibility, false); // Default value
      expect(result.createdAt, null);
      expect(result.updatedAt, null);
      expect(result.user,
          isA<ReviewerProfileResponseModel>()); // Assuming a default user is created
      expect(result.images, []);
      expect(result.videos, []);
      expect(result.voted, 0); // Default value
    });
  });
}
