import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_item_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_state.dart';

class PriceItemUpdateBloc
    extends Bloc<ItemPriceReviewEvent, ItemPriceChangeState> {
  final PriceItemUsecase priceItemUsecase;
  PriceItemUpdateBloc({required this.priceItemUsecase})
      : super(ItemPriceChangeInitial()) {
    on<ItemPriceChangeRequestEvent>(
      (event, emit) async {
        emit(ItemPriceChangeLoading());
        final response = await priceItemUsecase(
          ItemPriceReviewUseCaseParams(
            priceItemReviewRequestModel: event.priceItemReviewRequestModel,
          ),
        );
        response.fold((failure) {
          emit(ItemPriceChangeError(error: failure.errorMessage));
        }, (message) {
          emit(ItemPriceChangeSuccess(message: message));
        });
      },
    );
  }
}
