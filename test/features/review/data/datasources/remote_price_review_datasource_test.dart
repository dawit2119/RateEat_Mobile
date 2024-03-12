import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_price_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';

import 'remote_price_review_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
Future<void> main() async {
  late PriceReviewDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthSource;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuthSource = MockAuthenticationLocalSource();
    dataSource = PriceReviewDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuthSource);
  });

  group('priceReviewRequest', () {
    test('should return success message when the API call is successful',
        () async {
      // Arrange
      final requestModel = PriceReviewRequestModel(
        restaurantId: 'restaurant123',
        description: 'Great food!',
        images: [],
      );

      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Success'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.priceReviewRequest(
          priceReviewRequestModel: requestModel);

      // Assert
      expect(result, "Suggestion submitted successfully");
    });

    test('should throw ServerException on API error', () async {
      // Arrange
      final requestModel = PriceReviewRequestModel(
        restaurantId: 'restaurant123',
        description: 'Great food!',
        images: [],
      );

      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              statusCode: 400,
              data: {'message': 'Error'},
              requestOptions: RequestOptions(path: '')));

      // Act
      final call =
          dataSource.priceReviewRequest(priceReviewRequestModel: requestModel);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test('should throw ServerException on DioException', () async {
      // Arrange
      final requestModel = PriceReviewRequestModel(
        restaurantId: 'restaurant123',
        description: 'Great food!',
        images: [],
      );

      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'valid_token'));
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // Act
      final call =
          dataSource.priceReviewRequest(priceReviewRequestModel: requestModel);

      // Assert
      expect(call, throwsA(isA<ServerException>()));
    });
  });
}
