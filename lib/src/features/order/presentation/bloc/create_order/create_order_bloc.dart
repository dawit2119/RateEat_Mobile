import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

part 'create_order_event.dart';
part 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final CreateOrderUseCase createOrderUseCase;

  CreateOrderBloc({
    required this.createOrderUseCase,
  }) : super(CreateOrderInitial()) {
    on<CreateNewOrderEvent>(_onCreateOrderEvent);
  }

  void _onCreateOrderEvent(CreateNewOrderEvent event, emit) async {
    try {
      emit(
        CreateOrderActionsLoading(),
      );
      final response = await createOrderUseCase(
        CreateOrderUseCaseParams(
          order: event.order,
        ),
      );
      response.fold(
        (l) => emit(
          CreateOrderActionsFailed(errorMessage: l.errorMessage),
        ),
        (orderStatus) => emit(
          CreateOrderCreated(
            orderStatus: orderStatus,
          ),
        ),
      );
    } catch (e) {
      emit(
        const CreateOrderActionsFailed(errorMessage: "Unable to create order"),
      );
    }
  }
}
