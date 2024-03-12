import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/incentive_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

import '../../../../helper/json_reader.dart';

void main() {
  final user = UserModel(
    id: "1",
    telegramId: "1",
    facebookId: "1",
    userName: "John",
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '2013-04-20 12:00:00',
    email: 'doe@example.com',
    gender: 'male',
    roleId: '1',
    phoneNumber: '1234567890',
    image: 'http://example.com/doe.jpg',
    createdAt: DateTime.parse('2013-04-20 12:00:00'),
    updatedAt: DateTime.parse('2013-04-20 12:00:00'),
    token: 'token123',
    incentive: const IncentiveModel(
      id: '1',
      totalIncentivized: 100,
      pendingIncentive: 100,
    ),
    verified: 2,
  );

  group('UserModel', () {
    test('should be a subclass of User Entity', () {
      // Assert
      expect(user, isA<User>());
    });
    group('fromJson', () {
      test('should return a valid model when the JSON is received', () {
        // Arrange
        final result = json
            .decode(readJson('authentication/user_login_response_test.json'));
        // Act
        final userCredentialModel = UserModel.fromJson(result);
        // Assert
        expect(userCredentialModel, equals(user));
      });

      test('fromJson should handle missing and null fields', () {
        // Arrange
        const json = {
          'user': {
            'first_name': 'John',
            'last_name': null,
            'email': 'john@example.com',
          },
        };
        // Act
        final response = UserModel.fromJson(json);
        // Assert
        expect(response.firstName, 'John');
        expect(response.lastName, '');
        expect(response.phoneNumber, '');
        expect(response.email, 'john@example.com');
      });
      test(
          'fromJson should should return a valid model when the JSON is received for updated user',
          () {
        // Arrange
        const json = {
          'user': {
            'first_name': 'John',
            'last_name': null,
            'email': 'john@example.com',
          },
        };
        // Act
        final response = UserModel.fromJson(json);
        // Assert
        expect(response.firstName, 'John');
        expect(response.lastName, '');
        expect(response.phoneNumber, '');
        expect(response.email, 'john@example.com');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // arrange
        final user = UserModel(
          id: '1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );
        // act
        final result = user.toJson();
        // assert
        expect(result['id'], '1');
        expect(result['email'], 'test@example.com');
        expect(result['first_name'], 'John');
        expect(result['last_name'], 'Doe');
      });
    });
  });
}
