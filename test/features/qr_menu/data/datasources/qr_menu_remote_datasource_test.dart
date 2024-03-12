import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'qr_menu_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
Future<void> main() async {
  late MockDio mockDio;
  late QRMenuRemoteDatasource qrMenuRemoteDatasource;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() {
    mockDio = MockDio();
    qrMenuRemoteDatasource = QRMenuRemoteDatasource(dio: mockDio);
  });

  group('QRMenuRemoteDatasource', () {
    test('should return QRMenu when the response status is 200', () async {
      final qrMenuJson = <String, dynamic>{
        "data": [],
        "count": 0,
        "restaurant": {"id": "restaurant_id", "name": "Test Restaurant"},
      };

      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: qrMenuJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await qrMenuRemoteDatasource.getQRMenu(
        restaurantId: 'restaurant_id',
        page: 1,
        limit: 10,
        sortBy: 'name',
        sortType: 'asc',
        minPrice: null,
        maxPrice: null,
        minRating: null,
      );

      expect(result, isA<QRMenu>());
      // Add further checks based on the QRMenu structure, if necessary
    });

    test('should throw ServerException for non-200 response', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {"message": "error"},
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(
        () async => await qrMenuRemoteDatasource.getQRMenu(
          restaurantId: 'restaurant_id',
          page: 1,
          limit: 10,
          sortBy: 'name',
          sortType: 'asc',
          minPrice: null,
          maxPrice: null,
          minRating: null,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should return list of PriceRange when the response status is 200',
        () async {
      final priceRangeJson = {
        "data": {
          "predefinedPriceRanges": {
            "0-200": {"min": 0, "max": 200, "count": 22},
            // Add other ranges as needed
          }
        }
      };

      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: priceRangeJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await qrMenuRemoteDatasource.getNumberOfItemsPerPriceRange(
        restaurantId: 'restaurant_id',
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      );

      expect(result, isA<List<PriceRange>>());
      expect(result.length, greaterThan(0));
      // Add further checks based on the PriceRange structure, if necessary
    });

    test('should throw ServerException when Dio throws', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          data: {"message": "error"},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      expect(
        () async => await qrMenuRemoteDatasource.getNumberOfItemsPerPriceRange(
          restaurantId: 'restaurant_id',
          isFasting: false,
          category: null,
          minRating: null,
          query: '',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
