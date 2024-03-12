import '../entities/order_status.dart';

abstract class SocketIORepository {
  Stream<Order> getOrderStatus();
}
