import 'package:hive/hive.dart';

import '../../../features.dart';

abstract class LocalNearbyRestaurantDataProvider {
  Future<void> cacheNearbyRestaurants(List<Restaurant> restaurants);
  Future<List<Restaurant>> getNearbyRestaurants();
  Future<void> clearNearbyRestaurants();
}

class LocalNearbyRestaurantDataProviderImpl
    extends LocalNearbyRestaurantDataProvider {
  final restaurantBox = Hive.box<Restaurant>("nearbyRestaurantsBox");

  LocalNearbyRestaurantDataProviderImpl();

  @override
  Future<void> cacheNearbyRestaurants(List<Restaurant> restaurants) async {
    for (var restaurant in restaurants) {
      await restaurantBox.add(restaurant);
    }
  }

  @override
  Future<void> clearNearbyRestaurants() async {
    await restaurantBox.clear();
  }

  @override
  Future<List<Restaurant>> getNearbyRestaurants() async {
    return restaurantBox.values.toList();
  }
}
