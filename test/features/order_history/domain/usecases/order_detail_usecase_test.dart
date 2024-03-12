import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'order_detail_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderHistoryRepo>()])
void main() {
  late GetOrderDetailUseCase getOrderDetailUseCase;
  late MockOrderHistoryRepo mockOrderHistoryRepo;

  setUp(() {
    mockOrderHistoryRepo = MockOrderHistoryRepo();
    getOrderDetailUseCase =
        GetOrderDetailUseCase(orderHistoryRepo: mockOrderHistoryRepo);
  });

  group('test GetOrderDeetailUseCase', () {
    final GetOrderDetailParams params = GetOrderDetailParams(orderId: '123');
    test('should return OrderDetailModel on success', () async {
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

      when(mockOrderHistoryRepo.getOrderDetail(orderId: params.orderId))
          .thenAnswer((_) async => Right(orderDetailModel));

      final result = await getOrderDetailUseCase(params);

      expect(result, Right(orderDetailModel));
      verify(mockOrderHistoryRepo.getOrderDetail(orderId: params.orderId))
          .called(1);
    });

    test('should return failure on error', () async {
      final failure = ServerFailure(errorMessage: 'Server Error');

      when(mockOrderHistoryRepo.getOrderDetail(orderId: params.orderId))
          .thenAnswer((_) async => Left(failure));

      final result = await getOrderDetailUseCase(params);

      expect(result, Left(failure));
      verify(mockOrderHistoryRepo.getOrderDetail(orderId: params.orderId))
          .called(1);
    });
  });
}
