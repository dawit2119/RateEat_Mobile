import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'map_function_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AllRestaurantsDataProvider>(),
])
void main() {
  late MapFunctionRepoImpl mapFunctionRepoImpl;
  late MockAllRestaurantsDataProvider mockAllRestaurantsDataProvider;

  setUp(() {
    mockAllRestaurantsDataProvider = MockAllRestaurantsDataProvider();
    mapFunctionRepoImpl = MapFunctionRepoImpl(
        allRestaurantsDataProvider: mockAllRestaurantsDataProvider);
  });

  const int limit = 1;
  const double latitude = 1.0;
  const double longitude = 1.0;

  group('fetch all restaurants', () {
    test('should return the number of restaurants', () async {
      // arrange
      when(
        mockAllRestaurantsDataProvider.fetchAllRestaurants(
          limit: limit,
          latitude: latitude,
          longitude: longitude,
          radius: 1.0,
        ),
      ).thenAnswer(
        (_) async => [],
      );

      // act
      final result = await mapFunctionRepoImpl.fetchAllRestaurants(
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: 1.0,
      );
      // assert
      expect(
        result,
        equals(
          Right(
            AllRestaurantsSuccess(restaurants: const []),
          ),
        ),
      );
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockAllRestaurantsDataProvider.fetchAllRestaurants(
          limit: limit,
          latitude: latitude,
          longitude: longitude,
          radius: 1.0,
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result = await mapFunctionRepoImpl.fetchAllRestaurants(
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: 1.0,
      );
      // assert
      expect(result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
    });
  });
}
