import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import 'order_socket_status_bloc_test.mocks.dart';

@GenerateMocks([OrderSocketIOClient])
void main() {
  late OrderSocketStatusBloc orderSocketStatusBloc;
  late MockOrderSocketIOClient mockOrderSocketIOClient;

  setUp(() {
    mockOrderSocketIOClient = MockOrderSocketIOClient();
    orderSocketStatusBloc = OrderSocketStatusBloc();
  });

  group('OrderSocketStatusBloc', () {
    blocTest<OrderSocketStatusBloc, OrderSocketStatusState>(
      'emits [OrderSocketLoadingState, OrderSocketConnectedState] when socket is already connected',
      build: () {
        when(mockOrderSocketIOClient.socket!.connected).thenReturn(true);
        return orderSocketStatusBloc;
      },
      act: (bloc) => bloc.add(OrderConnectSocket()),
      expect: () => <OrderSocketStatusState>[
        OrderSocketLoadingState(),
        OrderSocketConnectedState(),
      ],
    );

    blocTest<OrderSocketStatusBloc, OrderSocketStatusState>(
      'emits [OrderSocketLoadingState, OrderSocketFailedState] when socket connection fails',
      build: () {
        when(mockOrderSocketIOClient.socket!.connected).thenReturn(false);
        when(mockOrderSocketIOClient.socket!.connect())
            .thenThrow(Exception('Socket connection error'));
        return orderSocketStatusBloc;
      },
      act: (bloc) => bloc.add(OrderConnectSocket()),
      expect: () => <OrderSocketStatusState>[
        OrderSocketLoadingState(),
        const OrderSocketFailedState(
            errorMessage: 'Exception: Socket connection error'),
      ],
    );

    blocTest<OrderSocketStatusBloc, OrderSocketStatusState>(
      'emits [OrderSocketConnectedState] when OrderSocketConnected event is added and socket is not yet connected',
      build: () => orderSocketStatusBloc,
      act: (bloc) => bloc.add(const OrderSocketConnected()),
      expect: () => <OrderSocketStatusState>[
        OrderSocketConnectedState(),
      ],
    );

    blocTest<OrderSocketStatusBloc, OrderSocketStatusState>(
      'emits [OrderSocketFailedState] with a custom error message when OrderSocketFailed event is added',
      build: () => orderSocketStatusBloc,
      act: (bloc) => bloc
          .add(const OrderSocketFailed(errorMessage: 'Custom error message')),
      expect: () => <OrderSocketStatusState>[
        const OrderSocketFailedState(errorMessage: 'Custom error message'),
      ],
    );
  });
}
