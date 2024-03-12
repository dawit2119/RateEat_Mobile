import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

import 'remote_item_detail_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() async {
  late ItemDataProviderImpl itemDataProvider;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late MockDio mockDio;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    itemDataProvider = ItemDataProviderImpl(dio: mockDio);

    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
    when(mockAuthenticationLocalSource.getUserCredential())
        .thenReturn(LocalUserModel(token: "mock token"));
  });

  group('ItemDataProviderImpl', () {
    final String itemId = '1';
    final Map<String, dynamic> jsonResponse = {
      'data': {
        'id': itemId,
        'name': 'Sample Item',
      },
    };

    test('getItem returns ItemModel on successful response', () async {
      when(mockDio.get(any, options: anyNamed("options")))
          .thenAnswer((_) async => Response(
                data: jsonResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await itemDataProvider.getItem(itemId: itemId);

      expect(result, isA<ItemModel>());
      expect(result.itemId, itemId);
      verify(mockDio.get("$baseURL/items/$itemId",
              options: anyNamed('options')))
          .called(1);
    });

    test('getItem throws ServerException on error', () async {
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() async => await itemDataProvider.getItem(itemId: itemId),
          throwsA(isA<ServerException>()));
    });

    test(
        'getItemRecommendations returns List<ItemModel> on successful response',
        () async {
      final recommendationsResponse = {
        'data': {
          'recommendations': [
            {'itemId': '1', 'itemName': 'Recommendation 1'},
            {'itemId': '2', 'itemName': 'Recommendation 2'},
          ],
        },
      };

      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: recommendationsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result =
          await itemDataProvider.getItemRecommendations(itemId: itemId);

      expect(result, isA<List<ItemModel>>());
      expect(result.length, 2);
      verify(mockDio.get("$baseURL/items/$itemId/recommendations")).called(1);
    });

    test('getItemRecommendations throws ServerException on error', () async {
      when(mockDio.get(any))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
          () async =>
              await itemDataProvider.getItemRecommendations(itemId: itemId),
          throwsA(isA<ServerException>()));
    });

    test(
        'getPopularItemsReviews returns PopularItemReviewsResponseModel on successful response',
        () async {
      final reviewsResponse = {
        'data': {
          'itemReviews': [
            {'id': "1", 'rating': 4.5, 'comment': "sample comment"},
            {'id': "1", 'rating': 4.5, 'comment': "sample comment"}
          ],
        },
      };

      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: reviewsResponse,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result =
          await itemDataProvider.getPopularItemsReviews(itemId: itemId);

      expect(result, isA<PopularItemReviewsResponseModel>());
      verify(mockDio.get(
              "$baseURL/items/$itemId/reviews?sortedBy=popularity&limit=5",
              options: anyNamed('options')))
          .called(1);
    });

    test('getPopularItemsReviews throws ServerException on error', () async {
      when(mockDio.get(any, options: anyNamed('options')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
          () async =>
              await itemDataProvider.getPopularItemsReviews(itemId: itemId),
          throwsA(isA<ServerException>()));
    });
  });
}
