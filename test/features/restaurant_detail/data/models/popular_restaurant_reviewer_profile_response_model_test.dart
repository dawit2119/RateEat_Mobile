import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviewer_profile_response.dart';

void main() {
  group('PopularRestaurantReviewerProfileResponseModel', () {
    final tPopularRestaurantReviewerProfileResponseModel =
        PopularRestaurantReviewerProfileResponseModel(
      id: 'user1',
      firstName: 'John',
      lastName: 'Doe',
      image: 'profile.jpg',
      verified: 1,
    );

    final tJson = {
      'id': 'user1',
      'firstName': 'John',
      'lastName': 'Doe',
      'image': 'profile.jpg',
      'verified': 1,
    };

    final tMap = {
      'id': 'user1',
      'firstName': 'John',
      'lastName': 'Doe',
      'image': 'profile.jpg',
      'verified': 1,
    };

    test(
        'should be a subclass of PopularRestaurantReviewerProfileResponse entity',
        () {
      expect(tPopularRestaurantReviewerProfileResponseModel,
          isA<PopularRestaurantReviewerProfileResponse>());
    });

    test('should return a valid model from json', () {
      // act
      final result =
          PopularRestaurantReviewerProfileResponseModel.fromJson(tJson);
      // assert
      expect(result, equals(tPopularRestaurantReviewerProfileResponseModel));
    });

    test('should return a valid model from map', () {
      // act
      final result =
          PopularRestaurantReviewerProfileResponseModel.fromMap(tMap);
      // assert
      expect(result, equals(tPopularRestaurantReviewerProfileResponseModel));
    });

    test('should return a json map containing the proper data', () {
      // act
      final result = tPopularRestaurantReviewerProfileResponseModel.toJson();
      // assert
      expect(result, equals(tJson));
    });
    test('should return a map containing the proper data', () {
      // act
      final result = tPopularRestaurantReviewerProfileResponseModel.toMap();
      // assert
      expect(result, equals(tMap));
    });

    test('fromJson should handle null values correctly', () {
      final jsonWithNulls = {
        'id': 'user2',
        'firstName': null,
        'lastName': null,
        'image': null,
        'verified': null,
      };

      final modelWithNulls =
          PopularRestaurantReviewerProfileResponseModel.fromJson(jsonWithNulls);

      expect(modelWithNulls.id, 'user2');
      expect(modelWithNulls.firstName, '');
      expect(modelWithNulls.lastName, '');
      expect(modelWithNulls.image, '');
      expect(modelWithNulls.verified, 0);
    });

    test('fromMap should handle null values correctly', () {
      final mapWithNulls = {
        'id': 'user2',
        'firstName': null,
        'lastName': null,
        'image': null,
        'verified': null,
      };

      final modelWithNulls =
          PopularRestaurantReviewerProfileResponseModel.fromMap(mapWithNulls);

      expect(modelWithNulls.id, 'user2');
      expect(modelWithNulls.firstName, '');
      expect(modelWithNulls.lastName, '');
      expect(modelWithNulls.image, '');
      expect(modelWithNulls.verified, 0);
    });

    test('toJson should handle null values correctly', () {
      final modelWithNulls = PopularRestaurantReviewerProfileResponseModel(
        id: 'user2',
        firstName: '',
        lastName: '',
        image: '',
        verified: null,
      );
      final json = modelWithNulls.toJson();
      expect(json['id'], 'user2');
      expect(json['firstName'], '');
      expect(json['lastName'], '');
      expect(json['image'], '');
      expect(json['verified'], null);
    });
    test('toMap should handle null values correctly', () {
      final modelWithNulls = PopularRestaurantReviewerProfileResponseModel(
        id: 'user2',
        firstName: '',
        lastName: '',
        image: '',
        verified: null,
      );
      final map = modelWithNulls.toMap();
      expect(map['id'], 'user2');
      expect(map['firstName'], '');
      expect(map['lastName'], '');
      expect(map['image'], '');
      expect(map['verified'], null);
    });
    test('toJson should handle empty string values correctly', () {
      final modelWithEmptyStrings =
          PopularRestaurantReviewerProfileResponseModel(
        id: 'user3',
        firstName: '',
        lastName: '',
        image: '',
        verified: 0,
      );
      final json = modelWithEmptyStrings.toJson();
      expect(json['id'], 'user3');
      expect(json['firstName'], '');
      expect(json['lastName'], '');
      expect(json['image'], '');
      expect(json['verified'], 0);
    });

    test('toMap should handle empty string values correctly', () {
      final modelWithEmptyStrings =
          PopularRestaurantReviewerProfileResponseModel(
        id: 'user3',
        firstName: '',
        lastName: '',
        image: '',
        verified: 0,
      );
      final map = modelWithEmptyStrings.toMap();
      expect(map['id'], 'user3');
      expect(map['firstName'], '');
      expect(map['lastName'], '');
      expect(map['image'], '');
      expect(map['verified'], 0);
    });
  });
}
