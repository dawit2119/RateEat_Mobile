import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final CancelOrderUseCase cancelOrderUseCase;

  CancelOrderBloc({
    required this.cancelOrderUseCase,
  }) : super(CancelOrderRequestInitial()) {
    on<CancelOrderRequestEvent>(_onCancelOrderOrderEvent);
  }

  void _onCancelOrderOrderEvent(CancelOrderRequestEvent event, emit) async {
    try {
      emit(
        CancelOrderRequestLoading(),
      );
      final response = await cancelOrderUseCase(
        CancelOrderUseCaseParams(
          orderId: event.orderId,
          reason: event.reason,
        ),
      );
      response.fold(
        (l) => emit(
          CancelOrderRequestFailed(errorMessage: l.errorMessage),
        ),
        (status) => emit(
          CancelOrderRequestSuccess(
            status: status,
          ),
        ),
      );
    } catch (e) {
      emit(
        const CancelOrderRequestFailed(errorMessage: "Unable to cancel order"),
      );
    }
  }
}
