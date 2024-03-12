import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_socket_impl.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_web_socket.dart';

import 'order_history_socket_impl_test.mocks.dart';

@GenerateMocks([OrderHistoryWebSocket])
void main() {
  late MockOrderHistoryWebSocket mockWebSocket;
  late OrderHistorySocketImpl orderHistorySocketImpl;

  setUp(() {
    mockWebSocket = MockOrderHistoryWebSocket();
    orderHistorySocketImpl = OrderHistorySocketImpl();
  });

  test('should join room and handle order events', () {
    final context = MockBuildContext();
    final restaurantId = '123';

    when(mockWebSocket.socket?.emitWithAckAsync('', any)).thenReturn(null);

    orderHistorySocketImpl.getOrderStatus(context, restaurantId);

    final orderData = {
      'order': {'id': '1', 'status': 'confirmed'}
    };
  });
}

class MockBuildContext extends Mock implements BuildContext {}
