import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/order_status.dart';
import 'package:rateeat_mobile/src/features/order/domain/repositories/socket_io_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'socket_io_repository_test.mocks.dart';

@GenerateMocks([SocketIORepository])
void main() {
  late MockSocketIORepository mockSocketIORepository;

  setUp(() {
    mockSocketIORepository = MockSocketIORepository();
  });

  group('SocketIORepository', () {
    test('should emit order updates via stream', () {
      // Arrange
      final order1 = Order(
        orderId: '123',
        time: '12:30 PM',
        title: 'Pizza Order',
        isCompleted: false,
        isCurrent: true,
      );

      final order2 = Order(
        orderId: '123',
        time: '12:45 PM',
        title: 'Pizza Order',
        isCompleted: true,
        isCurrent: false,
      );

      final controller = StreamController<Order>();
      when(mockSocketIORepository.getOrderStatus())
          .thenAnswer((_) => controller.stream);

      // Act & Assert
      expectLater(mockSocketIORepository.getOrderStatus(),
          emitsInOrder([order1, order2]));

      // Emit orders
      controller.add(order1);
      controller.add(order2);
      controller.close();
    });
  });
}
