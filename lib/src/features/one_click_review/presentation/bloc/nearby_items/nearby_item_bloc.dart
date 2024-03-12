import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurant_items_usecase.dart';

part 'nearby_item_event.dart';
part 'nearby_item_state.dart';

class NearbyItemBloc extends Bloc<NearbyItemEvent, NearbyItemState> {
  final GetNearByRestaurantItemsUseCase getNearByItemsUseCase;
  NearbyItemBloc({required this.getNearByItemsUseCase})
      : super(const NearbyItemInitial(itemName: '')) {
    on<GetNearbyItemsEvent>(_getNearByItems);
  }
  Future<void> _getNearByItems(
      GetNearbyItemsEvent event, Emitter<NearbyItemState> emit) async {
    //* Get Items
    final List<NearByItemResponse> prevNearByItems = (state is NearbyItemLoaded)
        ? (state as NearbyItemLoaded).nearbyItems
        : [];

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(NearbyItemLoading(itemName: state.itemName));
    } else {
      emit(
        NearbyItemNextLoaded(
            nearbyItems: prevNearByItems, itemName: state.itemName),
      );
    }

    Either<Failure, List<NearByItemResponse>> nearByItems;
    nearByItems = await getNearByItemsUseCase(GetNearByRestaurantItemsParams(
      nearByItemRequestModel: NearByItemRequestModel(
        page: event.page,
        limit: event.limit,
        itemName: event.itemName,
        restaurantId: event.restaurantId,
      ),
    ));

    //* Emit the response
    emit(
      nearByItems.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return NearbyItemFailure(
              message: failure.errorMessage, itemName: state.itemName);
        }
        //* Second page error message
        return NearbyItemLoaded(
          status: false,
          nearbyItems: prevNearByItems,
          itemName: state.itemName,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          return NearbyItemLoaded(
            status: true,
            itemName: state.itemName,
            hasReachedMax: success.isEmpty,
            nearbyItems: List.of(prevNearByItems)..addAll(success),
          );
        }
        //* first page Success
        return NearbyItemLoaded(
          status: true,
          hasReachedMax: false,
          nearbyItems: success,
          itemName: state.itemName,
        );
      }),
    );
  }
}
