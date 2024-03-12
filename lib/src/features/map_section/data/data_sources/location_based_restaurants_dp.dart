import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class LocationRestaurantsRemoteSource {
  Future<int> getRestaurantsBasedOnLocation(
      {required double lat, required double long, required double radius});
}

class LocationBasedRestaurantRemoteSourceImpl
    implements LocationRestaurantsRemoteSource {
  final Dio dio;

  LocationBasedRestaurantRemoteSourceImpl({required this.dio});
  @override
  Future<int> getRestaurantsBasedOnLocation(
      {required double lat,
      required double long,
      required double radius}) async {
    try {
      final response = await dio.get(
        "https://rateeat-backend-ij7jnmwh2q-zf.a.run.app/api/v1/restaurants/location/count?lat=$lat&long=$long&radius=$radius",
      );
      if (response.statusCode == 200) {
        final count = response.data['count'];
        return count;
      } else {
        throw Exception('Failed to get restaurants count');
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
