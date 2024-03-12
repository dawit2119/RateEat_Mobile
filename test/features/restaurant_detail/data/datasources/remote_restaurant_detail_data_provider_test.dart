import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/remote_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_menu_item.dart';

import 'remote_restaurant_detail_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() async {
  late RestaurantDetailDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    dataSource = RestaurantDetailDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator.registerSingleton<AuthenticationLocalSource>(
        mockAuthenticationLocalSource);
  });

  tearDown(() {
    dpLocator.reset();
  });
  group('getRestaurantDetail', () {
    const String tRestaurantId = 'restaurant123';
    // [
    //   id,
    //   name,
    //   openingHour,
    //   closingHour,
    //   isOpen,
    //   averagePrice,
    //   averageRating,
    //   numberOfReviews,
    //   popularityIndex,
    //   userId,
    //   createdAt,
    //   updatedAt,
    //   restaurantTags,
    //   restaurantImages,
    //   restaurantVideos,
    //   restaurantLocations,
    //   restaurantPhoneNumbers,
    //   distance,
    //   walkingTime,
    //   ridingTime,
    //   doShowAvailabilityAlert,
    //   lastPriceUpdate,
    // ];
    // 1, Test, null, null, null, null, null, null, null, null, 2025-03-04 10:47:30.048425, 2025-03-04 10:47:30.048425, null, null, null, null, null, , , , false, null)
    // 1, Test, null, null, false, 0.0, 0.0, 0, 0, null, 2025-03-04 10:47:30.048425, 2025-03-04 10:47:30.048425, [], [], [], [], [], , , , false, null)
    final tRestaurantModel = RestaurantModel(
        id: '1',
        name: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOpen: false,
        averagePrice: 0.0,
        averageRating: 0.0,
        numberOfReviews: 0,
        popularityIndex: 0,
        restaurantImages: [],
        restaurantTags: [],
        restaurantLocations: [],
        restaurantPhoneNumbers: [],
        restaurantVideos: []);

    test('should perform a GET request on the correct URL with no query params',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'data': tRestaurantModel.toMap()},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      await dataSource.getRestaurantDetail(restaurantId: tRestaurantId);
      // assert
      verify(mockDio.get('$baseURL/restaurants/$tRestaurantId'));
    });

    test('should perform a GET request on the correct URL with query params',
        () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'data': tRestaurantModel.toMap()},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
      // act
      await dataSource.getRestaurantDetail(
          restaurantId: tRestaurantId, latitude: 12.2, longitude: 12.3);
      // assert
      verify(mockDio.get('$baseURL/restaurants/$tRestaurantId',
          queryParameters: {"latitude": 12.2, "longitude": 12.3}));
    });

    test('should return RestaurantModel when the response code is 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'data': tRestaurantModel.toMap()},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      final result =
          await dataSource.getRestaurantDetail(restaurantId: tRestaurantId);
      // assert
      expect(result, equals(tRestaurantModel));
    });

    test('should throw an exception when the response code is not 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenThrow(Exception());
      // act
      final call = dataSource.getRestaurantDetail;
      // assert
      expect(() => call(restaurantId: tRestaurantId), throwsException);
    });
  });

  group('getRestaurantItems', () {
    const String tRestaurantId = 'restaurant123';
    const int tLimit = 10;
    const int tPage = 1;
    final tItemModelList = [
      ItemModel(
        itemId: '1',
        itemName: 'Item 1',
        description: 'desc',
        price: 100,
        itemImages: [],
        numberOfReviews: 5,
        imageUrl:
            "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
      ),
      ItemModel(
        itemId: '2',
        itemName: 'Item 2',
        description: 'desc',
        price: 200,
        itemImages: [],
        numberOfReviews: 5,
        imageUrl:
            "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
      ),
    ];

    test('should perform a GET request on the correct URL', () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'data': [tItemModelList[0].toJson(), tItemModelList[1].toJson()]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      await dataSource.getRestaurantItems(
          restaurantId: tRestaurantId, limit: tLimit, page: tPage);
      // assert
      verify(mockDio.get(
          '$baseURL/restaurants/$tRestaurantId/items?limit=$tLimit&page=$tPage'));
    });

    test('should return List<ItemModel> when the response code is 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'data': [tItemModelList[0].toJson(), tItemModelList[1].toJson()]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      final result = await dataSource.getRestaurantItems(
          restaurantId: tRestaurantId, limit: tLimit, page: tPage);
      // assert
      expect(result, equals(tItemModelList));
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'message': "Error"},
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      final call = dataSource.getRestaurantItems;
      // assert
      expect(
          () => call(restaurantId: tRestaurantId, limit: tLimit, page: tPage),
          throwsA(isA<ServerException>()));
    });
  });

  group('getPopularItems', () {
    const String tRestaurantId = 'restaurant123';
    final tRestaurantMenuItemList = [
      RestaurantMenuItemModel(
        id: '1',
        name: 'Item 1',
        description: 'desc',
        price: 100,
        averageRating: 4.5,
      ),
      RestaurantMenuItemModel(
        id: '2',
        name: 'Item 2',
        description: 'desc',
        price: 200,
        averageRating: 4.0,
      ),
    ];

    test('should perform a GET request on the correct URL', () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'data': [
                tRestaurantMenuItemList[0].toJson(),
                tRestaurantMenuItemList[1].toJson()
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      await dataSource.getPopularItems(restaurantId: tRestaurantId);
      // assert
      verify(mockDio.get(
          '$baseURL/restaurants/$tRestaurantId/items?latitude=9.0302570&longitude=38.7624079&limit=6&sortedBy=rate'));
    });

    test('should return List<RestaurantMenuItem> when the response code is 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'data': [
                tRestaurantMenuItemList[0].toJson(),
                tRestaurantMenuItemList[1].toJson()
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      final result =
          await dataSource.getPopularItems(restaurantId: tRestaurantId);
      // assert
      expect(result, equals(tRestaurantMenuItemList));
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'message': "Error"},
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ));
      // act
      final call = dataSource.getPopularItems;
      // assert
      expect(() => call(restaurantId: tRestaurantId),
          throwsA(isA<ServerException>()));
    });
  });

  group('getPopularRestaurantReviews', () {
    const String tRestaurantId = 'restaurant123';
    final tPopularRestaurantReviewsResponseModel =
        PopularRestaurantReviewsResponseModel(
      reviews: [],
      ratingsCount: [0, 0, 0, 0, 0],
      averageRating: 0,
      numberOfReviews: 0,
    );
    final tUserCredential = LocalUserModel(token: 'testToken');
    test('should perform a GET request on the correct URL', () async {
      // arrange
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(tUserCredential);
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'data': tPopularRestaurantReviewsResponseModel.toJson()},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
      // act

      await dataSource.getPopularRestaurantReviews(restaurantId: tRestaurantId);
      // assert
      verify(
        mockDio.get(
          '$baseURL/restaurants/$tRestaurantId/reviews?sortedBy=popularity&limit=5',
          options: anyNamed('options'),
        ),
      );
    });
    test('should perform a GET request on the correct URL when user is null',
        () async {
      // arrange
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(null);
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'data': tPopularRestaurantReviewsResponseModel.toJson()},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
      // act
      await dataSource.getPopularRestaurantReviews(restaurantId: tRestaurantId);
      // assert
      verify(mockDio.get(
          '$baseURL/restaurants/$tRestaurantId/reviews?sortedBy=popularity&limit=5',
          options: anyNamed('options')));
    });
    test(
        'should return PopularRestaurantReviewsResponseModel when the response code is 200',
        () async {
      // arrange
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(tUserCredential);
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'data': tPopularRestaurantReviewsResponseModel.toJson()},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
      // act
      final result = await dataSource.getPopularRestaurantReviews(
          restaurantId: tRestaurantId);
      // assert
      expect(result, equals(tPopularRestaurantReviewsResponseModel));
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // arrange
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(tUserCredential);
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'message': "Error"},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));
      // act
      final call = dataSource.getPopularRestaurantReviews;
      // assert
      expect(() => call(restaurantId: tRestaurantId),
          throwsA(isA<ServerException>()));
    });
    test(
        'should throw ServerException with custom message when DioException occurs',
        () async {
      final errorMessage = 'Custom error message';
      final response = Response(
          data: {'message': errorMessage},
          statusCode: 400,
          requestOptions: RequestOptions(path: ""));
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(tUserCredential);
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(path: ""), response: response));

      final call = dataSource.getPopularRestaurantReviews;

      expect(
          () => call(restaurantId: tRestaurantId),
          throwsA(isA<ServerException>().having(
              (e) => e.errorMessage, 'errorMessage', equals(errorMessage))));
    });
    test(
        'should throw ServerException with default message when exception occurs',
        () async {
      final exception = Exception("Error");
      when(mockAuthenticationLocalSource.getUserCredential())
          .thenReturn(tUserCredential);
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(exception);

      final call = dataSource.getPopularRestaurantReviews;

      expect(
          () => call(restaurantId: tRestaurantId),
          throwsA(isA<ServerException>().having((e) => e.errorMessage,
              'errorMessage', equals(exception.toString()))));
    });
  });
}
