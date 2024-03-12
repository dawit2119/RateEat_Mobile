import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import 'order_status_bloc_test.mocks.dart';

@GenerateMocks([GetOrderStatusUseCase])
void main() {
  late OrderStatusBloc orderStatusBloc;
  late MockGetOrderStatusUseCase mockOrderStatusUseCase;
  late OrderModel order;

  setUp(() {
    mockOrderStatusUseCase = MockGetOrderStatusUseCase();
    orderStatusBloc =
        OrderStatusBloc(orderStatusUseCase: mockOrderStatusUseCase);

    order = OrderModel(
      id: '123',
      orderConfirmedAt: DateTime.now(),
      paymentConfirmedAt: DateTime.now(),
      orderPlacedAt: DateTime.now(),
      orderCompletedAt: null,
      orderRejectedAt: null,
      orderCanceledAt: null,
      totalNumberOfItems: 1,
      totalPrice: 20,
      orderItems: const [],
      estimatedWaitingTime: 30,
      orderMessage: 'Order confirmed',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  });

  group('OrderStatusBloc', () {
    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] when GetOrderStatusEvent is added and succeeds',
      build: () {
        when(mockOrderStatusUseCase.call(any))
            .thenAnswer((_) async => Right(order));
        return orderStatusBloc;
      },
      act: (bloc) => bloc.add(const GetOrderStatusEvent(orderId: '123')),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        isA<OrderStatusUpdated>(),
      ],
      verify: (_) {
        verify(mockOrderStatusUseCase.call(any)).called(1);
      },
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdateFailed] when GetOrderStatusEvent is added and fails',
      build: () {
        when(mockOrderStatusUseCase.call(any)).thenAnswer((_) async =>
            Left(ServerFailure(errorMessage: 'Failed to fetch order status')));
        return orderStatusBloc;
      },
      act: (bloc) => bloc.add(const GetOrderStatusEvent(orderId: '123')),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        const OrderStatusUpdateFailed(
            errorMessage: 'Failed to fetch order status'),
      ],
      verify: (_) {
        verify(mockOrderStatusUseCase.call(any)).called(1);
      },
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with confirmed order when OrderConfirmedEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(OrderConfirmedEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, confirmed: order),
      ],
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with payment confirmed order when PaymentConfirmedEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(PaymentConfirmedEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order, confirmed: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, confirmed: order, paid: order),
      ],
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with started order when OrderStartedEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(OrderStartedEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, started: order),
      ],
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with completed order when OrderCompletedEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(OrderCompletedEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, completed: order),
      ],
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with rejected order when OrderRejectedEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(OrderRejectedEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, rejected: order),
      ],
    );

    blocTest<OrderStatusBloc, OrderStatusState>(
      'emits [OrderStatusUpdatedInProgress, OrderStatusUpdated] with cancelled order when OrderCancelledEvent is added',
      build: () => orderStatusBloc,
      act: (bloc) => bloc.add(OrderCancelledEvent(orderStatus: order)),
      seed: () => OrderStatusUpdated(created: order),
      expect: () => [
        OrderStatusUpdatedInProgress(),
        OrderStatusUpdated(created: order, cancelled: order),
      ],
    );
  });
}
