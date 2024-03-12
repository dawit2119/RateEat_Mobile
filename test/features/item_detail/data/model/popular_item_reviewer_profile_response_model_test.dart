import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviewer_profile_response_model.dart';

void main() {
  group('PopularItemReviewerProfileResponseModel', () {
    test('creates an instance correctly', () {
      final model = PopularItemReviewerProfileResponseModel(
        id: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        image: 'https://example.com/image.jpg',
        verified: 1,
      );

      expect(model.id, 'user1');
      expect(model.firstName, 'John');
      expect(model.lastName, 'Doe');
      expect(model.image, 'https://example.com/image.jpg');
      expect(model.verified, 1);
    });

    test('fromJson creates an instance from JSON', () {
      final json = {
        "id": "user1",
        "firstName": "John",
        "lastName": "Doe",
        "image": "https://example.com/image.jpg",
        "verified": 1,
      };

      final model = PopularItemReviewerProfileResponseModel.fromJson(json);

      expect(model.id, 'user1');
      expect(model.firstName, 'John');
      expect(model.lastName, 'Doe');
      expect(model.image, 'https://example.com/image.jpg');
      expect(model.verified, 1);
    });

    test('fromJson handles missing fields', () {
      final json = {
        "id": "user1",
        // Only providing 'id' to test default values for other fields
      };

      final model = PopularItemReviewerProfileResponseModel.fromJson(json);

      expect(model.firstName, ''); // Default value
      expect(model.lastName, ''); // Default value
      expect(model.image, ''); // Default value
      expect(model.verified, 0); // Default value
    });

    test('toJson converts model to JSON', () {
      final model = PopularItemReviewerProfileResponseModel(
        id: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        image: 'https://example.com/image.jpg',
        verified: 1,
      );

      final json = model.toJson();

      expect(json['id'], 'user1');
      expect(json['firstName'], 'John');
      expect(json['lastName'], 'Doe');
      expect(json['image'], 'https://example.com/image.jpg');
      expect(json['verified'], 1);
    });
  });
}
