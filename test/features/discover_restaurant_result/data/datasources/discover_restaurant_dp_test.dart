import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/datasources/discover_restaurant_dp.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

import 'discover_restaurant_dp_test.mocks.dart';

// Mock class for Dio
@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() {
  late DiscoverRestaurantDataProvider dataProvider;
  late MockDio mockDio;

  setUp(() async {
    await dotenv.load(fileName: ".env");
    baseURL = dotenv.get('BASE_URL');
    mockDio = MockDio();
    dataProvider = DiscoverRestaurantDataProvider(dio: mockDio);
  });

  group('getDiscoverRestaurantResults', () {
    final latitude = 10.0;
    final longitude = 20.0;
    final radius = 5.0;
    final maxPrice = 50.0;
    final minRating = 4.0;
    final limit = 10;
    final tags = ['vegan', 'gluten-free'];
    final sorting = 'rating';
    final fasting = false;
    final page = 1;
    final maxTravelTime = 30;
    final transportMode = TransportMode.driving;

    test('returns a list of DiscoverRestaurantResultModel on success',
        () async {
      // Arrange
      final responseData = {
        'data': [
          {'id': "1", 'name': 'Restaurant 1'},
          {'id': "2", 'name': 'Restaurant 2'},
        ]
      };
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      // Act
      final results = await dataProvider.getDiscoverRestaurantResults(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        maxPrice: maxPrice,
        minRating: minRating,
        limit: limit,
        tags: tags,
        sorting: sorting,
        fasting: fasting,
        page: page,
        maxTravelTime: maxTravelTime,
        transportMode: transportMode,
      );

      // Assert
      expect(results, isA<List<DiscoverRestaurantResultModel>>());
      expect(results.length, 2);
      expect(results[0].id, "1");
      expect(results[1].id, "2");
    });

    test('throws ServerException on non-200 response', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: {}, statusCode: 500, requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(
        () async => await dataProvider.getDiscoverRestaurantResults(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          maxPrice: maxPrice,
          minRating: minRating,
          limit: limit,
          tags: tags,
          sorting: sorting,
          fasting: fasting,
          page: page,
          maxTravelTime: maxTravelTime,
          transportMode: transportMode,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException on Dio error', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      // Act & Assert
      expect(
        () async => await dataProvider.getDiscoverRestaurantResults(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          maxPrice: maxPrice,
          minRating: minRating,
          limit: limit,
          tags: tags,
          sorting: sorting,
          fasting: fasting,
          page: page,
          maxTravelTime: maxTravelTime,
          transportMode: transportMode,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
