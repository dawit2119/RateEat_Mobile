import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/location_based_restaurants_dp.dart';

import 'location_based_restaurants_dp_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() {
  late LocationBasedRestaurantRemoteSourceImpl remoteSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    remoteSource = LocationBasedRestaurantRemoteSourceImpl(dio: mockDio);
  });

  group('LocationBasedRestaurantRemoteSourceImpl Tests', () {
    test('getRestaurantsBasedOnLocation returns count on success', () async {
      // Arrange
      final lat = 12.34;
      final long = 56.78;
      final radius = 1000.0;
      final responseData = {'count': 5};

      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final count = await remoteSource.getRestaurantsBasedOnLocation(
        lat: lat,
        long: long,
        radius: radius,
      );

      // Assert
      expect(count, 5);
    });

    test('getRestaurantsBasedOnLocation throws ServerException on failure',
        () async {
      // Arrange
      final lat = 12.34;
      final long = 56.78;
      final radius = 1000.0;

      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {},
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act & Assert
      expect(
        () async => await remoteSource.getRestaurantsBasedOnLocation(
          lat: lat,
          long: long,
          radius: radius,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('getRestaurantsBasedOnLocation throws ServerException on error',
        () async {
      // Arrange
      final lat = 12.34;
      final long = 56.78;
      final radius = 1000.0;

      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        response:
            Response(statusCode: 500, requestOptions: RequestOptions(path: '')),
      ));

      // Act & Assert
      expect(
        () async => await remoteSource.getRestaurantsBasedOnLocation(
          lat: lat,
          long: long,
          radius: radius,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
