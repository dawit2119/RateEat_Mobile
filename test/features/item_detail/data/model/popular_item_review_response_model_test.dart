import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_review_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviewer_profile_response_model.dart';

import 'popular_item_review_response_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationLocalSource>(),
])
void main() {
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;

  group('PopularItemReviewResponseModel', () {
    setUp(() async {
      mockAuthenticationLocalSource = MockAuthenticationLocalSource();
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(
        LocalUserModel(token: "mock token"),
      );
      await dpLocator.reset();
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => mockAuthenticationLocalSource);
    });
    test('creates an instance correctly', () {
      final model = PopularItemReviewResponseModel(
        id: '1',
        rating: 4.5,
        comment: 'Great item!',
        upVote: 5,
        downVote: 1,
        visibility: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: PopularItemReviewerProfileResponseModel(
          id: 'user1',
          firstName: 'John',
          lastName: 'Doe',
          image: 'https://example.com/image.jpg',
        ),
        images: ['https://example.com/image1.jpg'],
        videos: ['https://example.com/video1.mp4'],
        voted: 1,
      );

      expect(model.id, '1');
      expect(model.rating, 4.5);
      expect(model.comment, 'Great item!');
      expect(model.upVote, 5);
      expect(model.downVote, 1);
      expect(model.visibility, true);
      expect(model.user?.firstName, 'John');
      expect(model.images, ['https://example.com/image1.jpg']);
      expect(model.videos, ['https://example.com/video1.mp4']);
      expect(model.voted, 1);
    });

    test('fromJson creates an instance from JSON', () {
      final json = {
        "id": "1",
        "rating": 4.5,
        "comment": "Great item!",
        "upVote": 5,
        "downVote": 1,
        "visibility": true,
        "createdAt": "2023-01-01T00:00:00.000Z",
        "updatedAt": "2023-01-02T00:00:00.000Z",
        "user": {
          "id": "user1",
          "firstName": "John",
          "lastName": "Doe",
          "image": "https://example.com/image.jpg"
        },
        "images": ["https://example.com/image1.jpg"],
        "videos": [
          {"url": "https://example.com/video1.mp4"}
        ],
        "voted": 1,
      };

      final model = PopularItemReviewResponseModel.fromJson(json);

      expect(model.id, '1');
      expect(model.rating, 4.5);
      expect(model.comment, 'Great item!');
      expect(model.upVote, 5);
      expect(model.downVote, 1);
      expect(model.visibility, true);
      expect(model.user?.id, 'user1');
      expect(model.images, ['https://example.com/image1.jpg']);
      expect(model.videos, ['https://example.com/video1.mp4']);
      expect(model.voted, 1);
    });

    test('fromJson handles missing user data', () {
      final json = <String, dynamic>{
        // "id": "1",
        // "rating": 4.5,
        // "comment": "Great item!",
        // "upVote": 5,
        // "downVote": 1,
        // "visibility": true,
        // "createdAt": "2023-01-01T00:00:00.000Z",
        // "updatedAt": "2023-01-02T00:00:00.000Z",
        // "images": ["https://example.com/image1.jpg"],
        // "videos": [
        //   {"url": "https://example.com/video1.mp4"}
        // ],
        // "voted": 1,
      };

      final model = PopularItemReviewResponseModel.fromJson(json);

      expect(model.user?.firstName, isNotNull);
      expect(model.id, isNotNull);
      expect(model.rating, isNotNull);
      expect(model.comment, isNotNull);
      expect(model.upVote, isNotNull);
      expect(model.downVote, isNotNull);
      expect(model.visibility, isNotNull);
    });
  });
}
