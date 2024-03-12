import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/constants/urls.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/catagories_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/catagory_model.dart';

import '../../../add_to_favorite/data/datasources/remote_favorite_datasource_test.mocks.dart';

void main() {
  late CatagoriesDataProvider dataProvider;
  late MockDio mockDio;
  late String baseURL;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    mockDio = MockDio();
    dataProvider = CatagoriesDataProvider(dio: mockDio);
    baseURL = dotenv.get('BASE_URL');
  });

  group('getCatagories', () {
    const restaurantId = '123';
    final mockResponseData = {
      "success": true,
      "allMenuItems": 21,
      "data": [
        {
          "id": "4fe129cd-215f-4261-9377-7592cf1a60c3",
          "name": "Sandwich",
          "is_approved": true,
          "url": "",
          "menu_id": "0e74b18c-dcd3-496f-8304-65e1e35d9e67",
          "createdAt": "2023-10-15T10:33:35.301Z",
          "updatedAt": "2023-10-15T10:33:35.301Z",
          "item": [
            {"id": "dca7bb34-88f9-4c84-b915-1345b9dd440d"}
          ]
        }
      ]
    };

    test('get the list of category when resposne is sucess', () async {
      when(mockDio.get(
              '$baseURL/api/v1/restaurants/$restaurantId/menu/categories',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              requestOptions: RequestOptions(
                  data: mockResponseData,
                  path:
                      '$baseURL/api/v1/restaurants/$restaurantId/menu/categories')));
      await expectLater(await dataProvider.getCatagories(restaurantId),
          isA<List<Category>>());
    });

    test('should throw a ServerException when DioException occurs', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Something went wrong'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      // Act
      final call = dataProvider.getCatagories(restaurantId);

      // Assert
      expect(() => call, throwsA(isA<ServerException>()));
      verify(mockDio.get(
          'https://rateeat-backend-ij7jnmwh2q-zf.a.run.app/api/v1/restaurants/$restaurantId/menu/categories'));
    });

    test(
        'should throw a ServerException with generic message when an unknown error occurs',
        () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(Exception('Unknown error'));

      // Act
      final call = dataProvider.getCatagories(restaurantId);

      // Assert
      expect(() => call, throwsA(isA<ServerException>()));
      verify(mockDio.get(
          'https://rateeat-backend-ij7jnmwh2q-zf.a.run.app/api/v1/restaurants/$restaurantId/menu/categories'));
    });
  });
}
