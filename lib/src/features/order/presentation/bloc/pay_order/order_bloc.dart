import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order/data/data.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

part 'pay_order_event.dart';
part 'pay_order_state.dart';

class PayOrderBloc extends Bloc<PayOrderEvent, PayOrderState> {
  final PayOrderUseCase payOrderUseCase;

  PayOrderBloc({
    required this.payOrderUseCase,
  }) : super(PaymentOrderInitial()) {
    on<CreatePaymentOrderEvent>(_onCreatePaymentOrderEvent);
  }

  void _onCreatePaymentOrderEvent(CreatePaymentOrderEvent event, emit) async {
    try {
      emit(
        PaymentOrderActionsLoading(),
      );
      final response = await payOrderUseCase(
        PaymentRequestUseCaseParams(
          paymentInfo: event.paymentInfo,
        ),
      );
      response.fold(
        (l) => emit(
          PaymentOrderActionsFailed(errorMessage: l.errorMessage),
        ),
        (url) => emit(
          PaymentOrderCreated(
            returnUrl: url,
          ),
        ),
      );
    } catch (e) {
      emit(
        const PaymentOrderActionsFailed(
            errorMessage: "Unable to get payment url"),
      );
    }
  }
}
