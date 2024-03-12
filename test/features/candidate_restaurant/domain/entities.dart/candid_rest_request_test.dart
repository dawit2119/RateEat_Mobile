import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/entities/candid_rest_request.dart';

void main() {
  group('CandidRestaurant', () {
    late CandidRestaurant candidRestaurant;

    setUp(() {
      candidRestaurant = CandidRestaurant(
        name: 'Test Restaurant',
        description: 'A great place to eat',
        menuImages: [File('path/to/image1.png')],
        restImages: [File('path/to/image2.png')],
      );
    });

    test('copyWith retains unchanged properties', () {
      // Act
      final newRestaurant = candidRestaurant.copyWith(
        name: 'New Restaurant',
        menuImages: [File('path/to/image3.png')],
      );

      // Assert
      expect(newRestaurant.name, 'New Restaurant');
      expect(newRestaurant.description, 'A great place to eat'); // Unchanged
      expect(newRestaurant.menuImages.length, 1); // Changed
      expect(newRestaurant.restImages!.length, 1); // Unchanged
      expect(
          newRestaurant.restImages![0].path, 'path/to/image2.png'); // Unchanged
    });

    test('copyWith updates optional properties', () {
      // Act
      final newRestaurant = candidRestaurant.copyWith(
        name: 'Test Restaurant',
        description: 'A new description',
        menuImages: [File('path/to/image5.png')],
        restImages: [File('path/to/image4.png')],
      );

      // Assert
      expect(newRestaurant.name, 'Test Restaurant'); // Unchanged
      expect(newRestaurant.description, 'A new description'); // Changed
      expect(newRestaurant.restImages!.length, 1); // Changed
      expect(
          newRestaurant.restImages![0].path, 'path/to/image4.png'); // Changed
    });

    test('copyWith doesnt update values when null is passed', () {
      // Act
      final newRestaurant = candidRestaurant.copyWith(
        name: 'Test Restaurant',
        menuImages: [File('path/to/image6.png')],
        restImages: null,
      );

      // Assert
      expect(newRestaurant.name, 'Test Restaurant'); // Unchanged
      expect(newRestaurant.description, 'A great place to eat'); // Unchanged
      expect(newRestaurant.restImages,
          candidRestaurant.restImages); // shows previous values
    });
  });
}
