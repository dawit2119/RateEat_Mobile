import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'remote_homepage_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() async {
  late RemoteHomeSourceImpl remoteHomeSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthLocalSource;

  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUpAll(() async {
    mockDio = MockDio();
    remoteHomeSource = RemoteHomeSourceImpl(dio: mockDio);
    mockAuthLocalSource = MockAuthenticationLocalSource();
    final dpLocator = GetIt.instance;
    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthLocalSource);
  });

  group('RemoteHomeSourceImpl', () {
    test('getTopRatedItems returns PopularItemsResponse on success', () async {
      // Arrange
      final mockResponse = {
        'data': [
          {'id': "1", 'name': 'Item 1'},
          {'id': "2", 'name': 'Item 2'},
        ],
        'count': 2,
      };
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: mockResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act
      final response = await remoteHomeSource.getTopRatedItems(
        limit: 10,
        page: 1,
        tags: ['tag1', 'tag2'],
      );

      // Assert
      expect(response.totalItems, 2);
      expect(response.items.length, 2);
      expect(response.items[0].itemName, 'Item 1');
    });

    test('getTopRatedItems throws NetworkException on failure', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ""),
        response: null,
        type: DioExceptionType.connectionError,
        error: 'Network Error',
      ));

      // Act & Assert
      expect(
          remoteHomeSource.getTopRatedItems(
            limit: 10,
            page: 1,
            tags: [],
          ),
          throwsA(isA<NetworkException>()));
    });

    test('getPromotions returns list of PromotionModel on success', () async {
      // Arrange
      final mockResponse = {
        'data': [
          {'id': "1", 'title': 'Promo 1'},
          {'id': "2", 'title': 'Promo 2'},
        ],
      };
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final promotions = await remoteHomeSource.getPromotions();

      // Assert
      expect(promotions.length, 2);
    });

    test('getPromotions throws ServerException on failure', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: null,
        type: DioExceptionType.connectionError,
        error: 'Server Error',
      ));

      // Act & Assert
      expect(remoteHomeSource.getPromotions(), throwsA(isA<ServerException>()));
    });

    test(
        'getRestaurantRecommendations returns list of RecommendedRestaurantModel',
        () async {
      // Arrange
      final mockResponse = {
        'data': [
          {'id': "1", 'name': 'Restaurant 1'},
          {'id': "2", 'name': 'Restaurant 2'},
        ],
      };
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final recommendations =
          await remoteHomeSource.getRestaurantRecommendations(
        limit: 10,
        page: 1,
        tags: [],
      );

      // Assert
      expect(recommendations.length, 2);
      expect(recommendations[0].name, 'Restaurant 1');
    });

    test('getRestaurantRecommendations throws ServerException on failure',
        () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: null,
        type: DioExceptionType.connectionError,
        error: 'Server Error',
      ));

      // Act & Assert
      expect(
          remoteHomeSource.getRestaurantRecommendations(
            limit: 10,
            page: 1,
            tags: [],
          ),
          throwsA(isA<ServerException>()));
    });
  });
}
