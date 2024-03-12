import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/data.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/data_sources/restaurant_menu_data_provider.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<File>(),
  MockSpec<MultipartFile>(),
])
import 'restaurant_menu_data_provider_test.mocks.dart';

void main() {
  late RestaurantMenuDataProviderImpl dataProvider;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthSource;
  late GetIt dpLocator;
  late String baseURL;

  const String restaurantId = 'rest123';
  const String categoryId = 'cat456';
  const String menuId = 'menu789';
  const String categoryName = 'Main Course';
  const String itemName = 'Delicious Burger';
  const String price = '9.99';

  setUp(() async {
    await dotenv.load(fileName: '.env');
    baseURL = dotenv.env['BASE_URL']!;
    mockDio = MockDio();
    mockAuthSource = MockAuthenticationLocalSource();

    // Set up the dependency locator mock
    dpLocator = GetIt.instance;
    if (!dpLocator.isRegistered<AuthenticationLocalSource>()) {
      dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuthSource);
    } else {
      dpLocator.unregister<AuthenticationLocalSource>();
      dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuthSource);
    }

    dataProvider = RestaurantMenuDataProviderImpl(dio: mockDio);
  });

  group('getRestaurantMenuItems', () {
    final testItemsResponse = {
      'data': [
        {
          'id': 'item1',
          'name': 'Burger',
          'price': 10.99,
          'description': 'Delicious burger',
          'images': ['image1.jpg'],
          'rating': 4.5,
          'reviews_count': 120
        },
        {
          'id': 'item2',
          'name': 'Pizza',
          'price': 12.99,
          'description': 'Tasty pizza',
          'images': ['image2.jpg'],
          'rating': 4.7,
          'reviews_count': 85
        }
      ]
    };

    test('should return list of items when API call is successful', () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/items?page=1&limit=10';

      when(mockDio.get(expectedUrl)).thenAnswer((_) async => Response(
            data: testItemsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: expectedUrl),
          ));

      // Act
      final result = await dataProvider.getRestaurantMenuItems(
        restaurantId: restaurantId,
        limit: 10,
        page: 1,
      );

      // Assert
      expect(result.length, 2);
      expect(result[0].price, 10.99);
      expect(result[1].price, 12.99);

      verify(mockDio.get(expectedUrl)).called(1);
    });

    test('should throw ServerException when API call fails', () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/items?page=1&limit=10';

      when(mockDio.get(expectedUrl)).thenThrow(DioException(
        requestOptions: RequestOptions(path: expectedUrl),
        error: 'Connection error',
        type: DioExceptionType.connectionError,
      ));

      // Act & Assert
      expect(
        () => dataProvider.getRestaurantMenuItems(
          restaurantId: restaurantId,
          limit: 10,
          page: 1,
        ),
        throwsA(isA<ServerException>().having(
          (e) => e.errorMessage,
          'error message',
          contains('Connection error'),
        )),
      );

      verify(mockDio.get(expectedUrl)).called(1);
    });
  });

  group('getRestaurantMenuCategoryItems', () {
    final testMenuResponse = {
      'data': [
        {
          'id': 'item1',
          'name': 'Burger',
          'price': 10.99,
          'description': 'Delicious burger',
          'images': ['image1.jpg'],
          'rating': 4.5,
          'reviews_count': 120,
          'categories': {'menu_id': menuId, 'name': 'Burgers'}
        },
        {
          'id': 'item2',
          'name': 'Cheeseburger',
          'price': 12.99,
          'description': 'Tasty cheeseburger',
          'images': ['image2.jpg'],
          'rating': 4.7,
          'reviews_count': 85,
          'categories': {'menu_id': menuId, 'name': 'Burgers'}
        }
      ],
      'count': 2
    };

    test(
        'should return menu with items when API call is successful with all parameters',
        () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/menu?page=1&limit=10&sortedBy=price&categoryId=$categoryId&searchTerm=burger';

      when(mockDio.get(expectedUrl)).thenAnswer((_) async => Response(
            data: testMenuResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: expectedUrl),
          ));

      // Act
      final result = await dataProvider.getRestaurantMenuCategoryItems(
        restaurantId: restaurantId,
        categoryId: categoryId,
        page: 1,
        limit: 10,
        query: 'burger',
        sortBy: 'price',
      );

      // Assert
      expect(result.id, menuId);
      expect(result.items.length, 2);
      expect(result.totalItemsCount, 2);
      expect(result.loadedItemsCount, 2);

      verify(mockDio.get(expectedUrl)).called(1);
    });

    test(
        'should return menu with items when API call is successful with minimal parameters',
        () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/menu?page=1&limit=10&sortedBy=default';

      when(mockDio.get(expectedUrl)).thenAnswer((_) async => Response(
            data: testMenuResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: expectedUrl),
          ));

      // Act
      final result = await dataProvider.getRestaurantMenuCategoryItems(
        restaurantId: restaurantId,
        categoryId: '',
        page: 1,
        limit: 10,
        query: '',
        sortBy: 'default',
      );

      // Assert
      expect(result.id, menuId);
      expect(result.items.length, 2);

      verify(mockDio.get(expectedUrl)).called(1);
    });

    test('should throw ServerException when API call fails', () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/menu?page=1&limit=10&sortedBy=price&categoryId=$categoryId';

      when(mockDio.get(expectedUrl)).thenThrow(DioException(
        requestOptions: RequestOptions(path: expectedUrl),
        error: 'Timeout',
        type: DioExceptionType.receiveTimeout,
      ));

      // Act & Assert
      expect(
        () => dataProvider.getRestaurantMenuCategoryItems(
          restaurantId: restaurantId,
          categoryId: categoryId,
          page: 1,
          limit: 10,
          query: '',
          sortBy: 'price',
        ),
        throwsA(isA<ServerException>().having(
          (e) => e.errorMessage,
          'error message',
          contains('Timeout'),
        )),
      );

      verify(mockDio.get(expectedUrl)).called(1);
    });

    test('should handle empty response data correctly', () async {
      // Arrange
      final expectedUrl =
          '$baseURL/restaurants/$restaurantId/menu?page=1&limit=10&sortedBy=price';
      final emptyResponse = {'data': [], 'count': 0};

      when(mockDio.get(expectedUrl)).thenAnswer((_) async => Response(
            data: emptyResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: expectedUrl),
          ));

      // Act
      final result = await dataProvider.getRestaurantMenuCategoryItems(
        restaurantId: restaurantId,
        categoryId: '',
        page: 1,
        limit: 10,
        query: '',
        sortBy: 'price',
      );

      // Assert
      expect(result.id, "");
      expect(result.items.length, 0);
      expect(result.totalItemsCount, 0);
      expect(result.loadedItemsCount, 0);

      verify(mockDio.get(expectedUrl)).called(1);
    });
  });

  group('addCandidateItem', () {
    final testUserCredential = LocalUserModel(token: 'test_token');
    final testItemResponse = {
      'data': {
        'id': 'item123',
        'name': itemName,
        'price': double.parse(price),
        'description': 'A delicious burger',
        'images': ['image1.jpg'],
        'rating': 0,
        'reviews_count': 0
      }
    };

    setUp(() {
      when(mockAuthSource.getUserCredential()).thenReturn(testUserCredential);
    });

    test('should successfully add a candidate item without images', () async {
      // Arrange
      when(mockDio.post(
        '$baseURL/candidate-items',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: testItemResponse,
            statusCode: 201,
            requestOptions: RequestOptions(path: '$baseURL/candidate-items'),
          ));

      // Act
      final result = await dataProvider.addCandidateItem(
        itemName: itemName,
        price: price,
        itemImages: null,
        menuId: menuId,
        categoryName: categoryName,
      );

      // Assert
      expect(result.itemName, itemName);
      expect(result.price, double.parse(price));

      verify(mockAuthSource.getUserCredential()).called(1);
      verify(mockDio.post(
        '$baseURL/candidate-items',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).called(1);
    });

    test('should throw ServerException when API call fails', () async {
      // Arrange
      when(mockDio.post(
        '$baseURL/candidate-items',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '$baseURL/candidate-items'),
        error: 'Bad request',
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'message': 'Invalid data'},
          requestOptions: RequestOptions(path: '$baseURL/candidate-items'),
        ),
      ));

      // Act & Assert
      expect(
        () => dataProvider.addCandidateItem(
          itemName: itemName,
          price: price,
          itemImages: [],
          menuId: menuId,
          categoryName: categoryName,
        ),
        throwsA(isA<ServerException>()),
      );

      verify(mockAuthSource.getUserCredential()).called(1);
      verify(mockDio.post(
        '$baseURL/candidate-items',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).called(1);
    });

    test('should handle file upload errors', () async {
      // Arrange
      final mockFile = MockFile();
      when(mockFile.path).thenThrow(Exception('File not found'));

      // Act & Assert
      expect(
        () => dataProvider.addCandidateItem(
          itemName: itemName,
          price: price,
          itemImages: [mockFile],
          menuId: menuId,
          categoryName: categoryName,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
