import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('FilterModel', () {
    late FilterModel filterModel;

    setUp(() {
      filterModel = FilterModel(
        tags: ['vegan', 'organic'],
        latitude: 9.03,
        longitude: 38.74,
        maxPrice: 50.0,
        minPrice: 10.0,
        distanceToTravel: 5.0,
        rating: 4.5,
      );
    });

    test('should create an instance with correct values', () {
      expect(filterModel.tags, ['vegan', 'organic']);
      expect(filterModel.latitude, 9.03);
      expect(filterModel.longitude, 38.74);
      expect(filterModel.maxPrice, 50.0);
      expect(filterModel.minPrice, 10.0);
      expect(filterModel.distanceToTravel, 5.0);
      expect(filterModel.rating, 4.5);
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedFilterModel = filterModel.copyWith(
        tags: ['gluten-free'],
        maxPrice: 60.0,
      );

      expect(updatedFilterModel.tags, ['gluten-free']);
      expect(updatedFilterModel.latitude, filterModel.latitude);
      expect(updatedFilterModel.longitude, filterModel.longitude);
      expect(updatedFilterModel.maxPrice, 60.0);
      expect(updatedFilterModel.minPrice, filterModel.minPrice);
      expect(updatedFilterModel.distanceToTravel, filterModel.distanceToTravel);
      expect(updatedFilterModel.rating, filterModel.rating);
    });

    test(
        'copyWith should return the same instance if no parameters are provided',
        () {
      final sameFilterModel = filterModel.copyWith();

      expect(sameFilterModel, filterModel);
    });
  });
}
