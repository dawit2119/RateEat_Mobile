import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class ItemsCountPerPriceBloc
    extends Bloc<ItemsCountPerPriceEvent, ItemsCountPerPriceState> {
  GetNumberOfItemsPerPriceRangeUsecase getNumberOfItemsPerPriceRangeUsecase;

  ItemsCountPerPriceBloc({required this.getNumberOfItemsPerPriceRangeUsecase})
      : super(ItemsCountPerPriceInitial()) {
    on<GetItemsCountPerPriceRange>((event, emit) async {
      emit(ItemsCountPerPriceLoading());
      final res = await getNumberOfItemsPerPriceRangeUsecase(
          GetNumberOfItemsPerPriceRangeParams(
        restaurantId: event.restaurantId,
        isFasting: event.isFasting,
        category: event.category,
        minRating: event.minRating,
        query: event.query,
      ));
      res.fold((error) {
        emit(ItemsCountPerPriceFailed(
          message: error.toString(),
        ));
      }, (data) {
        emit(ItemsCountPerPriceLoaded(
          priceRanges: data,
        ));
      });
    });
  }
}
