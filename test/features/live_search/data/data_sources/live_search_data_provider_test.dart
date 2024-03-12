import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/live_search_data_provider.dart';

import 'live_search_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() async {
  late LiveSearchDataProviderImpl dataProvider;
  late MockDio mockDio;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() {
    mockDio = MockDio();
    dataProvider = LiveSearchDataProviderImpl(dio: mockDio);
  });

  group('LiveSearchDataProviderImpl', () {
    test('searchRestaurants returns a list of RestaurantResult', () async {
      // Arrange
      final query = 'Pizza';
      final mockResponse = {
        "data": [
          {"id": "1", "name": "Pizza Place"}
        ]
      };

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      // Act
      final results = await dataProvider.searchRestaurants(query);

      // Assert
      expect(results, isA<List<RestaurantResult>>());
      expect(results.length, 1);
      expect(results.first.name, 'Pizza Place');
    });

    test('searchRestaurants throws NetworkException on error', () async {
      // Arrange
      final query = 'Pizza';
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionError));

      // Act & Assert
      expect(() async => await dataProvider.searchRestaurants(query),
          throwsA(isA<NetworkException>()));
    });

    test('searchItems returns a list of unique ItemModel', () async {
      // Arrange
      final query = 'Burger';
      final latitude = 10.0;
      final longitude = 20.0;
      final mockResponse = {
        "data": [
          {"name": "Burger", "id": "1"},
          {"name": "Burger", "id": "2"},
          {"name": "Fries", "id": "3"}
        ]
      };

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      // Act
      final results = await dataProvider.searchItems(query,
          latitude: latitude, longitude: longitude);

      // Assert
      expect(results, isA<List<ItemModel>>());
      expect(results.length, 2); // Unique items
    });

    test('getPopularRestaurants returns a list of RestaurantModel', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      final mockResponse = {
        "data": [
          {"id": "1", "name": "Popular Restaurant 1"},
        ]
      };

      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      // Act
      final results =
          await dataProvider.getPopularRestaurants(limit: limit, page: page);

      // Assert
      expect(results, isA<List<RestaurantModel>>());
      expect(results.length, 1);
      expect(results.first.name, 'Popular Restaurant 1');
    });

    test('getPopularRestaurants throws ServerException on error', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      when(mockDio.get(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError));

      // Act & Assert
      expect(
          () async => await dataProvider.getPopularRestaurants(
              limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });

    test('getPopularItems returns a list of ItemModel', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      final mockResponse = {
        "data": [
          {"name": "Popular Item 1", "id": "1"},
          {"name": "Popular Item 2", "id": "2"},
        ]
      };

      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      // Act
      final results =
          await dataProvider.getPopularItems(limit: limit, page: page);

      // Assert
      expect(results, isA<List<ItemModel>>());
      expect(results.length, 2);
      expect(results.first.itemName, 'Popular Item 1');
    });

    test('getPopularItems throws ServerException on error', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      when(mockDio.get(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError));

      // Act & Assert
      expect(
          () async =>
              await dataProvider.getPopularItems(limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });

    test('searchItems handles empty response gracefully', () async {
      // Arrange
      final query = 'NonExistentItem';
      final latitude = 10.0;
      final longitude = 20.0;
      final mockResponse = {"data": []};

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      // Act
      final results = await dataProvider.searchItems(query,
          latitude: latitude, longitude: longitude);

      // Assert
      expect(results, isA<List<ItemModel>>());
      expect(results.length, 0); // Should return an empty list
    });

    test('searchRestaurants handles non-200 response', () async {
      // Arrange
      final query = 'Pizza';
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: {},
              statusCode: 500,
              requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(() async => await dataProvider.searchRestaurants(query),
          throwsA(isA<NetworkException>()));
    });

    test('getPopularRestaurants handles non-200 response', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: {}, statusCode: 500, requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(
          () async => await dataProvider.getPopularRestaurants(
              limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });

    test('getPopularItems handles non-200 response', () async {
      // Arrange
      final limit = 10;
      final page = 1;
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: {}, statusCode: 500, requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(
          () async =>
              await dataProvider.getPopularItems(limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });
  });
}
