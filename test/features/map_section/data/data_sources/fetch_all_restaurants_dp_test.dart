import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'fetch_all_restaurants_dp_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() async {
  late AllRestaurantsDataProvider dataProvider;
  late MockDio mockDio;

  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() {
    mockDio = MockDio();
    dataProvider = AllRestaurantsDataProvider(dio: mockDio);
  });

  group('AllRestaurantsDataProvider Tests', () {
    test('fetchAllRestaurants returns a list of RestaurantModel on success',
        () async {
      // Arrange
      final responseData = {
        "data": [
          {"id": "1", "name": "Restaurant A"},
          {"id": "2", "name": "Restaurant B"},
        ]
      };
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      final result = await dataProvider.fetchAllRestaurants(
        limit: 10,
        latitude: 12.34,
        longitude: 56.78,
        radius: 1000,
      );

      // Assert
      expect(result, isA<List<RestaurantModel>>());
      expect(result.length, 2);
      expect(result[0].name, 'Restaurant A');
      expect(result[1].name, 'Restaurant B');
    });

    test('fetchAllRestaurants throws NetworkException on failure', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
        response:
            Response(statusCode: 500, requestOptions: RequestOptions(path: '')),
      ));

      // Act & Assert
      expect(
        () async => await dataProvider.fetchAllRestaurants(
          limit: 10,
          latitude: 12.34,
          longitude: 56.78,
          radius: 1000,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('fetchAllRestaurants handles non-200 response', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act & Assert
      expect(
        () async => await dataProvider.fetchAllRestaurants(
          limit: 10,
          latitude: 12.34,
          longitude: 56.78,
          radius: 1000,
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
