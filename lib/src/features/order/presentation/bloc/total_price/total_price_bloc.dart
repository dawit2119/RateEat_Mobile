import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../homepage/domain/entities/item.dart';
import '../../../domain/entities/total_price.dart';
import '../../../domain/use_cases/get_order_total_price_use_case.dart';

part 'total_price_event.dart';
part 'total_price_state.dart';

class TotalPriceBloc extends Bloc<TotalPriceEvent, TotalPriceState> {
  final GetOrderTotalPriceUseCase getOrderTotalPriceUseCase;

  TotalPriceBloc({
    required this.getOrderTotalPriceUseCase,
  }) : super(TotalPriceInitial()) {
    on<GetOrderTotalPriceEvent>(_onGetOrderTotalPriceEvent);
  }
  void _onGetOrderTotalPriceEvent(GetOrderTotalPriceEvent event, emit) async {
    try {
      emit(
        TotalPriceLoading(),
      );
      final response = await getOrderTotalPriceUseCase(
        GetOrderTotalPriceUseCaseParams(
          cart: event.cart,
        ),
      );
      response.fold(
        (l) => emit(
          TotalPriceFailed(errorMessage: l.errorMessage),
        ),
        (r) => emit(
          TotalPriceLoaded(
            totalPrice: r,
          ),
        ),
      );
    } catch (e) {
      emit(
        const TotalPriceFailed(errorMessage: "Unable to get total price"),
      );
    }
  }
}
