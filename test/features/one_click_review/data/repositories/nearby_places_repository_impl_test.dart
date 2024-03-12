import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/datasources/nearby_places_datasource.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/repositories/nearby_places_repository_impl.dart';

import 'data.dart';
import 'nearby_places_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NearbyPlacesDataSource>()])
void main() {
  late MockNearbyPlacesDataSource mockNearbyPlacesDataSource;
  late NearByPlacesRepositoryImpl nearByPlacesRepositoryImpl;

  setUp(() {
    mockNearbyPlacesDataSource = MockNearbyPlacesDataSource();
    nearByPlacesRepositoryImpl = NearByPlacesRepositoryImpl(
      nearbyPlacesDataSource: mockNearbyPlacesDataSource,
    );
  });
  final nearbyItemRequest = NearByItemRequestModel(
    restaurantId: "343438ufaf",
    itemName: "Burger",
    page: 1,
    limit: 10,
  );
  final nearbyRestaurantRequest = NearByRestaurantRequestModel(
    latitude: 9.03,
    longitude: 38.9,
    radius: 1000,
    page: 1,
    limit: 20,
    searchQuery: "Abc",
  );
  final draftReviewRequestModel = DraftReviewRequestModel(
    itemId: "3u384af",
    restaurantId: "eriuiurie",
    images: [],
    videos: [],
  );
  group(
    "Quick review repository test",
    () {
      test(
        "Should return items from nearby restaurant",
        () async {
          //arrange
          when(
            mockNearbyPlacesDataSource.getNearByRestaurantItems(
                nearByItemRequestModel: nearbyItemRequest),
          ).thenAnswer((_) async => dummyNearByItems);
          //act
          final result =
              await nearByPlacesRepositoryImpl.getNearByRestaurantItems(
            nearByItemRequestModel: nearbyItemRequest,
          );

          // assert
          expect(
            result,
            equals(
              Right(
                dummyNearByItems,
              ),
            ),
          );
        },
      );
      test(
        "Should return nearby restaurants",
        () async {
          when(
            mockNearbyPlacesDataSource.getNearByRestaurants(
                nearByRestaurantRequestModel: nearbyRestaurantRequest),
          ).thenAnswer(
            (_) async => dummyNearbyRestaurants,
          );
          //act
          final result = await nearByPlacesRepositoryImpl.getNearByRestaurants(
            nearByRestaurantRequestModel: nearbyRestaurantRequest,
          );

          // assert
          expect(
            result,
            equals(
              Right(
                dummyNearbyRestaurants,
              ),
            ),
          );
        },
      );
    },
  );
  test(
    "Should add new draft review",
    () async {
      //arrange
      when(
        mockNearbyPlacesDataSource.addReviewToDraft(
          draftReviewRequestModel: draftReviewRequestModel,
        ),
      ).thenAnswer(
        (_) async => "Draft review added",
      );
      //act
      final result = await nearByPlacesRepositoryImpl.addReviewToDraft(
        draftReviewRequestModel: draftReviewRequestModel,
      );

      // assert
      expect(
        result,
        const Right(
          "Draft review added",
        ),
      );
    },
  );
}
