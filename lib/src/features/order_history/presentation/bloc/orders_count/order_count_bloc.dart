import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/usecases/orders_count_usecase.dart';

part 'order_count_event.dart';
part 'order_count_state.dart';

class OrdersCountBloc extends Bloc<OrdersCountEvent, OrdersCountState> {
  final FetchOrdersCountUseCase fetchOrdersCountUseCase;

  OrdersCountBloc({required this.fetchOrdersCountUseCase})
      : super(OrdersCountInitial()) {
    on<FetchOrdersCount>(_getOrdersCount);
  }

  Future<void> _getOrdersCount(
      FetchOrdersCount event, Emitter<OrdersCountState> emit) async {
    emit(OrdersCountLoading());
    final ordersCount = await fetchOrdersCountUseCase(OrdersCountUseCaseParams(
      userId: event.userId,
      status: 'event.status',
    ));
    emit(ordersCount.fold(
      (failure) => OrdersCountError(message: failure.errorMessage),
      (ordersCount) => OrdersCountLoaded(count: ordersCount),
    ));
  }
}
