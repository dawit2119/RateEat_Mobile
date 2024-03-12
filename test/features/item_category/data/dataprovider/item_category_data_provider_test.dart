import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'item_category_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() async {
  late FoodCategoryDataProvider dataProvider;
  late MockDio mockDio;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() {
    mockDio = MockDio();
    dpLocator.reset();
    dpLocator.registerSingleton<Dio>(mockDio);
    dataProvider = FoodCategoryDataProvider();
  });

  tearDown(() {
    dpLocator.reset();
  });

  group('FoodCategoryDataProvider', () {
    test('searchFoodCategory returns list of ItemCategoryModel', () async {
      // Arrange
      final mockResponse = {
        "data": [
          {"id": "1", "name": "Fruits"},
          {"id": "2", "name": "Vegetables"},
        ]
      };

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: mockResponse,
          statusCode: 200,
        ),
      );

      // Act
      final result = await dataProvider.searchFoodCategory("Fruits", 1);

      // Assert
      expect(result, isA<List<ItemCategoryModel>>());
      expect(result.length, 2);
      expect(result[0].name, "Fruits");
      expect(result[1].name, "Vegetables");
    });

    test('searchFoodCategory throws Exception on error', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(Exception('Network Error'));

      // Act & Assert
      expect(dataProvider.searchFoodCategory("Fruits", 1), throwsException);
    });

    test('getTagSuggestion returns list of ItemCategoryModel', () async {
      // Arrange
      final mockResponse = {
        "data": [
          {"id": "1", "name": "Dairy"},
          {"id": "2", "name": "Grains"},
        ]
      };

      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: mockResponse,
          statusCode: 200,
        ),
      );

      // Act
      final result = await dataProvider.getTagSuggestion();

      // Assert
      expect(result, isA<List<ItemCategoryModel>>());
      expect(result.length, 2);
      expect(result[0].name, "Dairy");
      expect(result[1].name, "Grains");
    });

    test('getTagSuggestion throws NetworkException on error', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(Exception('Network Error'));

      // Act & Assert
      expect(dataProvider.getTagSuggestion(), throwsA(isA<NetworkException>()));
    });
  });
}
