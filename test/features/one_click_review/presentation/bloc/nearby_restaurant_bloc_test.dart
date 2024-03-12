import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_restaurant/nearby_restaurant_bloc.dart';

import '../../data/repositories/data.dart';
import 'nearby_restaurant_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetNearByRestaurantsUseCase>()])
void main() {
  late MockGetNearByRestaurantsUseCase mockGetNearByRestaurantsUseCase;
  late NearByRestaurantBloc nearbyItemBloc;

  setUp(() {
    mockGetNearByRestaurantsUseCase = MockGetNearByRestaurantsUseCase();
    nearbyItemBloc = NearByRestaurantBloc(
      getNearByRestaurantsUseCase: mockGetNearByRestaurantsUseCase,
    );
  });

  group("Nearby restaurants bloc unit test", () {
    test("Initial state should be AddReviewToDraftInitial", () {
      expect(
          nearbyItemBloc.state, const NearbyRestaurantInitial(searchQuery: ''));
    });
    final nearbyRestaurantRequest = NearByRestaurantRequestModel(
      latitude: 9.03,
      longitude: 38.9,
      radius: 1000,
      page: 1,
      limit: 20,
      searchQuery: "Abc",
    );
    blocTest<NearByRestaurantBloc, NearByRestaurantState>(
        "Should emit [ AddReviewToDraftLoading -> AddReviewToDraftSuccess]",
        build: () {
          when(
            mockGetNearByRestaurantsUseCase(
              GetNearByRestaurantsParams(
                nearByRestaurantRequestModel: nearbyRestaurantRequest,
              ),
            ),
          ).thenAnswer((_) async => Right(
                dummyNearbyRestaurants,
              ));
          return nearbyItemBloc;
        },
        act: (bloc) => bloc.add(
              GetNearbyRestaurantEvent(
                latitude: nearbyRestaurantRequest.latitude,
                longitude: nearbyRestaurantRequest.longitude,
                radius: nearbyRestaurantRequest.radius,
                page: nearbyRestaurantRequest.page,
                searchQuery: nearbyRestaurantRequest.searchQuery ?? "",
              ),
            ),
        expect: () => <NearByRestaurantState>[
              const NearbyRestaurantLoading(searchQuery: ""),
              NearbyRestaurantLoaded(
                status: true,
                nearbyRestaurants: dummyNearbyRestaurants,
                searchQuery: "",
              )
            ]);
  });
}
