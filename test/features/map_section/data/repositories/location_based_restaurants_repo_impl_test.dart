import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/location_based_restaurants_dp.dart';
import 'package:rateeat_mobile/src/features/map_section/data/repositories/location_based_restaurants_repo_impl.dart';

import 'location_based_restaurants_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationRestaurantsRemoteSource>(),
])
void main() {
  late LocationBasedRestaurantsRepositoryImpl
      locationBasedRestaurantsRepositoryImpl;
  late MockLocationRestaurantsRemoteSource mockLocationRestaurantsRemoteSource;

  setUp(() {
    mockLocationRestaurantsRemoteSource = MockLocationRestaurantsRemoteSource();
    locationBasedRestaurantsRepositoryImpl =
        LocationBasedRestaurantsRepositoryImpl(
            remoteSource: mockLocationRestaurantsRemoteSource);
  });

  const double lat = 1.0;
  const double long = 1.0;

  group('get restaurants based on location', () {
    test('should return the number of restaurants based on location', () async {
      // arrange
      when(
        mockLocationRestaurantsRemoteSource.getRestaurantsBasedOnLocation(
          lat: lat,
          long: long,
          radius: 1.0,
        ),
      ).thenAnswer(
        (_) async => 1,
      );

      // act
      final result = await locationBasedRestaurantsRepositoryImpl
          .getRestaurantsBasedOnLocation(lat: lat, long: long, radius: 1.0);
      // assert
      expect(result, equals(const Right(1)));
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockLocationRestaurantsRemoteSource.getRestaurantsBasedOnLocation(
            lat: lat, long: long, radius: 1.0),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result = await locationBasedRestaurantsRepositoryImpl
          .getRestaurantsBasedOnLocation(lat: lat, long: long, radius: 1.0);
      // assert
      expect(result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
    });
  });
}
