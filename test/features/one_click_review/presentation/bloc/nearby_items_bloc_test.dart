import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurant_items_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_items/nearby_item_bloc.dart';

import '../../data/repositories/data.dart';
import 'nearby_items_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetNearByRestaurantItemsUseCase>()])
void main() {
  late MockGetNearByRestaurantItemsUseCase mockGetNearByRestaurantItemsUseCase;
  late NearbyItemBloc nearbyItemBloc;

  setUp(() {
    mockGetNearByRestaurantItemsUseCase = MockGetNearByRestaurantItemsUseCase();
    nearbyItemBloc = NearbyItemBloc(
        getNearByItemsUseCase: mockGetNearByRestaurantItemsUseCase);
  });

  group("Nearby items bloc unit test", () {
    test("Initial state should be AddReviewToDraftInitial", () {
      expect(
        nearbyItemBloc.state,
        const NearbyItemInitial(itemName: ''),
      );
    });
    final nearbyItemRequest = NearByItemRequestModel(
      restaurantId: "343438ufaf",
      itemName: "Burger",
      page: 1,
      limit: 10,
    );
    blocTest<NearbyItemBloc, NearbyItemState>(
        "Should emit [ AddReviewToDraftLoading -> AddReviewToDraftSuccess]",
        build: () {
          when(mockGetNearByRestaurantItemsUseCase(
            GetNearByRestaurantItemsParams(
                nearByItemRequestModel: nearbyItemRequest),
          )).thenAnswer((_) async => Right(dummyNearByItems));
          return nearbyItemBloc;
        },
        act: (bloc) => bloc.add(
              const GetNearbyItemsEvent(
                restaurantId: '',
                itemName: '',
                page: 1,
              ),
            ),
        expect: () => <NearbyItemState>[
              const NearbyItemLoading(itemName: ''),
              NearbyItemLoaded(
                status: true,
                hasReachedMax: false,
                nearbyItems: dummyNearByItems,
                itemName: "",
              )
            ]);
  });
}
