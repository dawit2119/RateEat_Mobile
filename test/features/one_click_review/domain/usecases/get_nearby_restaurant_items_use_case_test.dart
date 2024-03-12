import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurant_items_usecase.dart';

import '../../data/repositories/data.dart';
import 'add_review_to_draft_use_case_test.mocks.dart';

void main() {
  late MockNearByPlacesRepository mockNearByPlacesRepository;
  late GetNearByRestaurantItemsUseCase getNearByRestaurantItemsUseCase;
  final nearbyItemRequest = NearByItemRequestModel(
    restaurantId: "343438ufaf",
    itemName: "Burger",
    page: 1,
    limit: 10,
  );

  setUp(() {
    mockNearByPlacesRepository = MockNearByPlacesRepository();
    getNearByRestaurantItemsUseCase = GetNearByRestaurantItemsUseCase(
      repository: mockNearByPlacesRepository,
    );
  });

  test("Should return nearby restaurant items", () async {
    //Arrange
    when(
      mockNearByPlacesRepository.getNearByRestaurantItems(
        nearByItemRequestModel: nearbyItemRequest,
      ),
    ).thenAnswer(
      (_) async => Right(dummyNearByItems),
    );
    //Act
    final result = await getNearByRestaurantItemsUseCase(
      GetNearByRestaurantItemsParams(nearByItemRequestModel: nearbyItemRequest),
    );
    expect(result, Right(dummyNearByItems));
    //Assert
    verify(
      mockNearByPlacesRepository.getNearByRestaurantItems(
        nearByItemRequestModel: nearbyItemRequest,
      ),
    );
    verifyNoMoreInteractions(
      mockNearByPlacesRepository,
    );
  });
}
