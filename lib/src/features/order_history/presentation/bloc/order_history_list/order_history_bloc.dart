import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final FetchOrderHistoryUseCase fetchOrderHistoryUseCase;

  OrderHistoryBloc({required this.fetchOrderHistoryUseCase})
      : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>(_getOrders);
  }

  Future<void> _getOrders(
      FetchOrderHistory event, Emitter<OrderHistoryState> emit) async {
    List<OrderHistory> previouslyLoadedOrders =
        state is OrderHistoryLoaded ? (state as OrderHistoryLoaded).orders : [];
    int page =
        state is OrderHistoryLoaded ? (state as OrderHistoryLoaded).page : 1;

    if (event.page == 1) {
      emit(OrderHistoryLoading());
    } else {
      emit(
        OrderHistoryNextLoading(
          orders: previouslyLoadedOrders,
          page: page,
        ),
      );
    }
    final response = await fetchOrderHistoryUseCase(OrderHistoryUseCaseParams(
      userId: event.userId,
      status: event.status,
      page: event.page,
      limit: event.limit,
    ));

    response.fold((error) {
      if (event.page == 1) {
        emit(
          OrderHistoryError(
            errorMessage: error.errorMessage,
          ),
        );
      } else {
        emit(
          OrderHistoryLoaded(
            orders: previouslyLoadedOrders,
            page: page,
          ),
        );
      }
    }, (orders) {
      if (event.page == 1) {
        emit(
          OrderHistoryLoaded(
            orders: orders,
            page: 2,
          ),
        );
      } else {
        emit(
          OrderHistoryLoaded(
            orders: previouslyLoadedOrders
              ..addAll(
                orders,
              ),
            hasReachedMax: orders.isEmpty,
            page: page + 1,
          ),
        );
      }
    });
  }
}
