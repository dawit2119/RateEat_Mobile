import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/discover_restaurant_model.dart';

void main() {
  group('DiscoverRestaurantModel', () {
    const tags = ['Italian', 'Pizza'];
    const latitude = 40.7128;
    const longitude = -74.0060;
    const maxPrice = 50.0;
    const minPrice = 10.0;
    const distanceToTravel = 5.0;
    const minRating = 4.0;
    const fasting = true;
    const searchQuery = 'best pizza';
    const sorting = 'price';
    const page = 1;
    const maxTravelTime = 18;
    const transportMode = TransportMode.walking;

    test('initial values', () {
      const model = DiscoverRestaurantModel(
        tags: tags,
        latitude: latitude,
        longitude: longitude,
        maxPrice: maxPrice,
        minPrice: minPrice,
        distanceToTravel: distanceToTravel,
        minRating: minRating,
        fasting: fasting,
        searchQuery: searchQuery,
        sorting: sorting,
        page: page,
        maxTravelTime: maxTravelTime,
        transportMode: transportMode,
      );

      expect(model.tags, tags);
      expect(model.latitude, latitude);
      expect(model.longitude, longitude);
      expect(model.maxPrice, maxPrice);
      expect(model.minPrice, minPrice);
      expect(model.distanceToTravel, distanceToTravel);
      expect(model.minRating, minRating);
      expect(model.fasting, fasting);
      expect(model.searchQuery, searchQuery);
      expect(model.sorting, sorting);
      expect(model.page, page);
      expect(model.maxTravelTime, maxTravelTime);
      expect(model.transportMode, transportMode);
    });

    test('copyWith returns a new instance with updated properties', () {
      const model = DiscoverRestaurantModel(
        tags: tags,
        latitude: latitude,
        longitude: longitude,
      );

      final updatedModel = model.copyWith(
        tags: ['Vegan', 'Pizza'],
        maxPrice: 60.0,
      );

      expect(updatedModel.tags, ['Vegan', 'Pizza']);
      expect(updatedModel.latitude, latitude);
      expect(updatedModel.longitude, longitude);
      expect(updatedModel.maxPrice, 60.0);
    });

    test('toString returns correct string representation', () {
      final model = DiscoverRestaurantModel(
        tags: tags,
        latitude: latitude,
        longitude: longitude,
      );

      expect(
        model.toString(),
        'tags: $tags latitude: $latitude longitude: $longitude maxPrice: null minPrice: null distanceToTravel: null rating: null fasting: null searchQuery: null sorting: ',
      );
    });

    test('equatable comparison works correctly', () {
      final model1 = DiscoverRestaurantModel(
        tags: tags,
        latitude: latitude,
        longitude: longitude,
      );

      final model2 = DiscoverRestaurantModel(
        tags: tags,
        latitude: latitude,
        longitude: longitude,
      );

      final model3 = DiscoverRestaurantModel(
        tags: ['Vegan'],
        latitude: latitude,
        longitude: longitude,
      );

      expect(model1, model2); // Should be equal
      expect(model1, isNot(model3)); // Should not be equal
    });

    test('default values are correctly assigned', () {
      final model = DiscoverRestaurantModel();

      expect(model.sorting, '');
      expect(model.page, 1);
      expect(model.maxTravelTime, 18);
      expect(model.transportMode, TransportMode.walking);
    });
  });
}
