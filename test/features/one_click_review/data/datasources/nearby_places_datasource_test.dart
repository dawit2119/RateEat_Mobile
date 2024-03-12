import "package:dio/dio.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/dp_injection/dp_injection.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/datasources/nearby_places_datasource.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_response_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_response_model.dart';

import '../../../authentication/data/repositories/authentication_repository_impl_test.mocks.dart';
import 'nearby_places_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
void main() {
  late MockDio mockDio;
  late NearbyPlacesDataSourceImpl nearbyPlacesDataSourceImpl;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  final token = LocalUserModel(token: 'token');

  late String baseUrl;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    baseUrl = dotenv.env['BASE_URL']!;
    mockDio = MockDio();
    nearbyPlacesDataSourceImpl = NearbyPlacesDataSourceImpl(dio: mockDio);

    mockAuthenticationLocalSource = MockAuthenticationLocalSource();

    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
  });

  group("test getNearbyRestaurants", () {
    final NearByRestaurantRequestModel nearByRestaurantRequestModel =
        NearByRestaurantRequestModel(
      latitude: 0.0,
      longitude: 0.0,
      radius: 1000,
      page: 1,
      limit: 10,
      searchQuery: "",
    );

    final latitude = 0.0;
    final longitude = 0.0;
    final radius = 1000;
    final page = 1;
    final limit = 10;
    final searchQuery = "";

    test('should return a list of NearByRestaurantResponseModel', () async {
      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {
              'data': [
                {"id": "1", "name": "Restaurant A", "currency": "USD"},
                {"id": "2", "name": "Restaurant B", "currency": "EUR"}
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await nearbyPlacesDataSourceImpl.getNearByRestaurants(
          nearByRestaurantRequestModel: nearByRestaurantRequestModel);

      expect(result, isA<List<NearByRestaurantResponseModel>>());
      expect(result.length, 2);
      expect(result[0].id, "1");
      expect(result[0].name, "Restaurant A");
      expect(result[0].currency, "USD");
      expect(result[1].id, "2");
      expect(result[1].name, "Restaurant B");
      expect(result[1].currency, "EUR");
    });

    test("test getNearbRestaurnatItems", () async {
      final NearByItemRequestModel nearByItemRequestModel =
          NearByItemRequestModel(
        restaurantId: "1",
        page: 1,
        limit: 10,
        itemName: "",
      );

      final restaurantId = "1";
      final page = 1;
      final limit = 10;
      final itemName = "";

      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {
              'data': [
                {"id": "1", "name": "Item A", "price": 10.0},
                {"id": "2", "name": "Item B", "price": 20.0}
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await nearbyPlacesDataSourceImpl.getNearByRestaurantItems(
          nearByItemRequestModel: nearByItemRequestModel);

      expect(result, isA<List<NearByItemResponseModel>>());
      expect(result.length, 2);
      expect(result[0].id, "1");
      expect(result[0].name, "Item A");

      expect(result[1].id, "2");
      expect(result[1].name, "Item B");
    });

    test('test addReviewToDraft', () async {
      final draftReviewRequestModel = DraftReviewRequestModel(
        restaurantId: "1",
        itemId: "1",
        images: [],
        videos: [],
      );
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {"message": "Review added successfully"},
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await nearbyPlacesDataSourceImpl.addReviewToDraft(
          draftReviewRequestModel: draftReviewRequestModel);

      expect(result, isA<String>());
    });
  });
}
