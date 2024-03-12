import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_price_review.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'remote_item_price_review_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
Future<void> main() async {
  late ItemPriceReviewDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuth;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuth = MockAuthenticationLocalSource();
    dataSource = ItemPriceReviewDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuth);
  });

  group('itemPriceReviewRequest', () {
    final testModel = PriceItemReviewRequestModel(
        itemId: '1', price: 100, description: 'Test review');

    test('should return success message when the API call is successful',
        () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
              statusCode: 201,
              data: {'message': 'Success'},
              requestOptions: RequestOptions(path: '')));

      final result = await dataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: testModel);

      expect(result, 'Suggestion submitted successfully');
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
          () async => await dataSource.itemPriceReviewRequest(
              itemPriceReviewRequestModel: testModel),
          throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when DioException occurs', () async {
      when(mockAuth.getUserCredential())
          .thenReturn(LocalUserModel(token: 'test_token'));
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
          () async => await dataSource.itemPriceReviewRequest(
              itemPriceReviewRequestModel: testModel),
          throwsA(isA<ServerException>()));
    });
  });
}
