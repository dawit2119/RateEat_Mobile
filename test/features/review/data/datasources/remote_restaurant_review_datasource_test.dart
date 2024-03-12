import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_restaurant_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthenticationLocalSource>()])
import 'remote_restaurant_review_datasource_test.mocks.dart';

Future<void> main() async {
  late RestaurantReviewDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuth;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuth = MockAuthenticationLocalSource();
    dataSource = RestaurantReviewDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuth);
  });

  group('addRestaurantReview', () {
    final testModel = AddRestaurantReviewRequestModel(
      restaurantId: '1',
      rating: 5,
      comment: 'Great food!',
    );

    test('should return success message when the API call is successful',
        () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Review added successfully'},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.addRestaurantReview(
          addRestaurantReviewRequestModel: testModel);

      expect(result, 'Review added successfully');
    });

    test('should throw ServerException when the API call fails', () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.addRestaurantReview(
              addRestaurantReviewRequestModel: testModel),
          throwsA(isA<ServerException>()));
    });
  });

  group('editRestaurantReview', () {
    final testModel = EditRestaurantReviewRequestModel(
      restaurantId: '1',
      reviewId: '1',
      rating: 4,
      comment: 'Updated review!',
    );

    test('should return success message when the API call is successful',
        () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.put(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              data: {'message': 'Review updated successfully'},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.editRestaurantReview(
          editRestaurantReviewRequestModel: testModel);

      expect(result, 'Review updated successfully');
    });

    test('should throw ServerException when the API call fails', () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.put(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.editRestaurantReview(
              editRestaurantReviewRequestModel: testModel),
          throwsA(isA<ServerException>()));
    });
  });

  group('deleteRestaurantReview', () {
    final testModel = DeleteRestaurantReviewRequestModel(
      restaurantId: '1',
      reviewId: '1',
    );

    test('should return success message when the API call is successful',
        () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 200,
              data: {'message': 'Review deleted successfully'},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel: testModel);

      expect(result, 'Review deleted successfully');
    });

    test('should throw ServerException when the API call fails', () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.delete(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.deleteRestaurantReview(
              deleteRestaurantReviewRequestModel: testModel),
          throwsA(isA<ServerException>()));
    });
  });

  group('getAllRestaurantReviewsByTime', () {
    test(
        'should return RestaurantReviewsResponseModel when the API call is successful',
        () async {
      final restaurantId = '1';
      final limit = 10;
      final page = 1;

      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 200,
              data: {'data': <String, dynamic>{}},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getAllRestaurantReviewsByTime(
          restaurantId: restaurantId, limit: limit, page: page);

      expect(result, isA<RestaurantReviewsResponseModel>());
    });

    test('should throw ServerException when the API call fails', () async {
      final restaurantId = '1';
      final limit = 10;
      final page = 1;

      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.getAllRestaurantReviewsByTime(
              restaurantId: restaurantId, limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });
  });

  group('getAllRestaurantReviewsByPopularity', () {
    test(
        'should return RestaurantReviewsResponseModel when the API call is successful',
        () async {
      final restaurantId = '1';
      final limit = 10;
      final page = 1;

      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 200,
              data: {'data': <String, dynamic>{}},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getAllRestaurantReviewsByPopularity(
          restaurantId: restaurantId, limit: limit, page: page);

      expect(result, isA<RestaurantReviewsResponseModel>());
    });

    test('should throw ServerException when the API call fails', () async {
      final restaurantId = '1';
      final limit = 10;
      final page = 1;

      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.getAllRestaurantReviewsByPopularity(
              restaurantId: restaurantId, limit: limit, page: page),
          throwsA(isA<ServerException>()));
    });
  });
}
