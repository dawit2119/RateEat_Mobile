import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurants_usecase.dart';

import '../../data/repositories/data.dart';
import 'add_review_to_draft_use_case_test.mocks.dart';

void main() {
  late MockNearByPlacesRepository mockNearByPlacesRepository;
  late GetNearByRestaurantsUseCase getNearByRestaurantsUseCase;
  final nearbyRestaurantRequest = NearByRestaurantRequestModel(
    latitude: 9.03,
    longitude: 38.9,
    radius: 1000,
    page: 1,
    limit: 20,
    searchQuery: "Abc",
  );

  setUp(() {
    mockNearByPlacesRepository = MockNearByPlacesRepository();
    getNearByRestaurantsUseCase = GetNearByRestaurantsUseCase(
      repository: mockNearByPlacesRepository,
    );
  });

  test("Should return nearby restaurants", () async {
    //Arrange
    when(
      mockNearByPlacesRepository.getNearByRestaurants(
        nearByRestaurantRequestModel: nearbyRestaurantRequest,
      ),
    ).thenAnswer(
      (_) async => Right(dummyNearbyRestaurants),
    );
    //Act
    final result = await getNearByRestaurantsUseCase(
      GetNearByRestaurantsParams(
          nearByRestaurantRequestModel: nearbyRestaurantRequest),
    );
    expect(result, Right(dummyNearbyRestaurants));
    //Assert
    verify(
      mockNearByPlacesRepository.getNearByRestaurants(
        nearByRestaurantRequestModel: nearbyRestaurantRequest,
      ),
    );
    verifyNoMoreInteractions(
      mockNearByPlacesRepository,
    );
  });
}
