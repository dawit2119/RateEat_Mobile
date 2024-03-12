import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

import 'order_detail_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetOrderDetailUseCase>()])
void main() {
  late OrderDetailBloc orderDetailBloc;
  late MockGetOrderDetailUseCase mockGetOrderDetailUseCase;

  setUp(() {
    mockGetOrderDetailUseCase = MockGetOrderDetailUseCase();
    orderDetailBloc = OrderDetailBloc(orderUseCase: mockGetOrderDetailUseCase);
  });

  tearDown(() {
    orderDetailBloc.close();
  });
  group('test OrderDetailBloc', () {
    final GetOrderDetailParams params = GetOrderDetailParams(orderId: '123');

    final String orderId = '123';

    final orderDetailModel = OrderDetailModel(
      id: '123',
      restaurantId: '456',
      totalNumberOfItems: 3,
      restaurantName: 'Test Restaurant',
      totalPrice: 29,
      estimatedWaitingTime: 45,
      orderMessage: 'Leave at the door',
      createdAt: DateTime.parse("2024-02-15T10:00:00Z"),
      updatedAt: DateTime.parse("2024-02-15T11:00:00Z"),
      orderItems: [
        OrderDetailItemModel(
          id: 'item789',
          itemId: 'item001',
          quantity: 2,
          item: OrderItemInfoModel(
            name: 'Pizza',
            price: 10,
            itemImages: [
              OrderItemImageEntity(url: 'https://example.com/pizza.jpg')
            ],
          ),
        )
      ],
      orderStatus: 'pending',
      orderType: 'delivery',
    );
    test('initial state should return OrderDetailInitial', () async {
      expect(orderDetailBloc.state, OrderDetailInitial());
    });

    blocTest(
        'emits [OrderHistoryStatusUpdateInProgress,OrderHistoryUpdated] when GetOrderDetailEvent Added',
        build: () {
          when(mockGetOrderDetailUseCase(any))
              .thenAnswer((_) async => Right(orderDetailModel));
          return orderDetailBloc;
        },
        act: (OrderDetailBloc bloc) =>
            bloc.add(GetOrderDetailEvent(orderId: orderId)),
        expect: () => [
              OrderHistoryStatusUpdatedInProgress(),
              isA<OrderHistoryStatusUpdated>(),
            ]);

    blocTest(
        'emits [OrderHistoryStatusUpdatedInProgress,OrderHistoryStatusUpdated] on OrderConfirmEvent added',
        build: () {
          when(mockGetOrderDetailUseCase(any))
              .thenAnswer((_) async => Right(orderDetailModel));
          return orderDetailBloc;
        },
        act: (OrderDetailBloc bloc) =>
            bloc.add(OrderConfirmedEvent(orderStatus: orderDetailModel)),
        expect: () => [
              OrderHistoryStatusUpdatedInProgress(),
              isA<OrderHistoryStatusUpdated>(),
            ]);

    blocTest(
      'emits [OrderHistoryStatusUpdatedInProgress, OrderHistoryStatusUpdated] on PaymentConfirmedEvent added',
      build: () {
        when(mockGetOrderDetailUseCase(any))
            .thenAnswer((_) async => Right(orderDetailModel));
        return orderDetailBloc;
      },
      act: (OrderDetailBloc bloc) =>
          bloc.add(PaymentConfirmedEvent(orderStatus: orderDetailModel)),
      expect: () => [
        OrderHistoryStatusUpdatedInProgress(),
        isA<OrderHistoryStatusUpdated>(),
      ],
    );

    blocTest(
        'emits [OrderHistoryStatusUpdatedInProgress, OrderHistoryStatusUpdated] on OrderStartedEvent added',
        build: () {
          when(mockGetOrderDetailUseCase(any))
              .thenAnswer((_) async => Right(orderDetailModel));
          return orderDetailBloc;
        },
        act: (OrderDetailBloc bloc) =>
            bloc.add(OrderStartedEvent(orderStatus: orderDetailModel)),
        expect: () => [
              OrderHistoryStatusUpdatedInProgress(),
              isA<OrderHistoryStatusUpdated>(),
            ]);

    blocTest(
        'emits [OrderHistoryStatusUpdatedInProgress,OrderHistoryStatusUpdated] on OrderCompletedEvent added',
        build: () {
          when(mockGetOrderDetailUseCase(any))
              .thenAnswer((_) async => Right(orderDetailModel));
          return orderDetailBloc;
        },
        act: (OrderDetailBloc bloc) =>
            bloc.add(OrderCompletedEvent(orderStatus: orderDetailModel)),
        expect: () => [
              OrderHistoryStatusUpdatedInProgress(),
              isA<OrderHistoryStatusUpdated>(),
            ]);

    blocTest(
        'emits [OrderHistoryStatusUpdatedInProgress,OrderHistoryStatusUpdated] on OrderRejectedEvent added',
        build: () {
          when(mockGetOrderDetailUseCase(any))
              .thenAnswer((_) async => Right(orderDetailModel));
          return orderDetailBloc;
        },
        act: (OrderDetailBloc bloc) =>
            bloc.add(OrderRejectedEvent(orderStatus: orderDetailModel)),
        expect: () => [
              OrderHistoryStatusUpdatedInProgress(),
              isA<OrderHistoryStatusUpdated>(),
            ]);

    blocTest(
      'emits [OrderHistoryStatusUpdatedInProgress,OrderHistoryStatusUpdated] on OrderCancelledEvent added',
      build: () {
        when(mockGetOrderDetailUseCase(any))
            .thenAnswer((_) async => Right(orderDetailModel));
        return orderDetailBloc;
      },
      act: (OrderDetailBloc bloc) =>
          bloc.add(OrderCancelledEvent(orderStatus: orderDetailModel)),
      expect: () => [
        OrderHistoryStatusUpdatedInProgress(),
        isA<OrderHistoryStatusUpdated>(),
      ],
    );

    blocTest(
      'emits OrderHistoryStatusUpdatedInProgress on added OrderDetailResetEvent',
      build: () {
        when(mockGetOrderDetailUseCase(any))
            .thenAnswer((_) async => Right(orderDetailModel));
        return orderDetailBloc;
      },
      act: (OrderDetailBloc bloc) => bloc.add(OrderDetailResetEvent()),
      expect: () => [
        OrderHistoryStatusUpdatedInProgress(),
      ],
    );
  });
}
