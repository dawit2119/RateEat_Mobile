import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/datasources/remote_favorite_datasource.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'remote_favorite_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() async {
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockLocalSource;
  late RemoteFavoriteSourceImpl remoteFavoriteSource;

  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUpAll(() async {
    mockDio = MockDio();
    mockLocalSource = MockAuthenticationLocalSource();
    remoteFavoriteSource = RemoteFavoriteSourceImpl(
      dio: mockDio,
      localSource: mockLocalSource,
    );
  });

  group('RemoteFavoriteSourceImpl', () {
    const String itemId = '123';
    const String restaurantId = '456';
    const String token = 'test_token';
    final String baseUrl = '$baseURL/favorites';

    // Create a LocalUserModel mock
    final localUserModel = LocalUserModel(token: token);

    test('addItemToFavorite returns true on success', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'itemId': itemId},
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: {},
            requestOptions: RequestOptions(path: baseUrl),
          ));

      final result =
          await remoteFavoriteSource.addItemToFavorite(itemId: itemId);

      expect(result, true);
    });

    test('addItemToFavorite throws ServerException on failure', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'itemId': itemId},
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: {},
            requestOptions: RequestOptions(path: baseUrl),
          ));

      expect(
          () async =>
              await remoteFavoriteSource.addItemToFavorite(itemId: itemId),
          throwsA(isA<ServerException>()));
    });

    test('addItemToFavorite throws ServerException on failure', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'itemId': itemId},
        options: anyNamed('options'),
      )).thenThrow(DioException(
          requestOptions: RequestOptions(path: baseUrl),
          response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: baseUrl),
              data: {"success": false, "message": "error"})));

      expect(
          () async =>
              await remoteFavoriteSource.addItemToFavorite(itemId: itemId),
          throwsA(isA<ServerException>()));
    });

    test('removeItemFromFavorite returns true on success', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.delete(
        '$baseUrl/item/$itemId',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: {},
            requestOptions: RequestOptions(path: '$baseUrl/item/$itemId'),
          ));

      final result =
          await remoteFavoriteSource.removeItemFromFavorite(itemId: itemId);

      expect(result, true);
    });

    test('removeItemFromFavorite throws ServerException on failure', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.delete(
        '$baseUrl/item/$itemId',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: {},
            requestOptions: RequestOptions(path: '$baseUrl/item/$itemId'),
          ));

      expect(
          () async =>
              await remoteFavoriteSource.removeItemFromFavorite(itemId: itemId),
          throwsA(isA<ServerException>()));
    });

    test('addRestaurantToFavorite returns true on success', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'restaurantId': restaurantId},
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: {},
            requestOptions: RequestOptions(path: baseUrl),
          ));

      final result = await remoteFavoriteSource.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, true);
    });

    test('addRestaurantToFavorite throws ServerException on failure', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'restaurantId': restaurantId},
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: {},
            requestOptions: RequestOptions(path: baseUrl),
          ));

      expect(
          () async => await remoteFavoriteSource.addRestaurantToFavorite(
              restaurantId: restaurantId),
          throwsA(isA<ServerException>()));
    });

    test('addRestaurantToFavorite throws ServerException on dio exception',
        () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.post(
        baseUrl,
        data: {'restaurantId': restaurantId},
        options: anyNamed('options'),
      )).thenThrow(DioException(
          requestOptions: RequestOptions(path: baseUrl),
          response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: baseUrl),
              data: {"success": false, "message": "error"})));

      expect(
          () async => await remoteFavoriteSource.addRestaurantToFavorite(
              restaurantId: restaurantId),
          throwsA(isA<ServerException>()));
    });

    test('removeRestaurantFromFavorite returns true on success', () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.delete(
        '$baseUrl/restaurant/$restaurantId',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 200,
            data: {},
            requestOptions:
                RequestOptions(path: '$baseUrl/restaurant/$restaurantId'),
          ));

      final result = await remoteFavoriteSource.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, true);
    });

    test('removeRestaurantFromFavorite throws ServerException on failure',
        () async {
      when(mockLocalSource.getUserCredential()).thenReturn(localUserModel);
      when(mockDio.delete(
        '$baseUrl/restaurant/$restaurantId',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: {},
            requestOptions:
                RequestOptions(path: '$baseUrl/restaurant/$restaurantId'),
          ));

      expect(
          () async => await remoteFavoriteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId),
          throwsA(isA<ServerException>()));
    });
  });
}
