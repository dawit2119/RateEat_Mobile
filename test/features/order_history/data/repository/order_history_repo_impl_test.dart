import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

import 'order_history_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderHistoryDataSource>()])
void main() {
  late OrderHistoryRepoImpl orderHistoryRepoImpl;
  late MockOrderHistoryDataSource mockOrderHistoryDataSource;

  setUp(() {
    mockOrderHistoryDataSource = MockOrderHistoryDataSource();
    orderHistoryRepoImpl = OrderHistoryRepoImpl(
        orderHistoryDataSource: mockOrderHistoryDataSource);
  });

  group('test getOrderHistory in orderHistoryRepoImpl', () {
    final OrderHistoryModel orderHistoryModel = OrderHistoryModel(
      id: '123',
      restaurantId: '456',
      totalNumberOfItems: 3,
      totalPrice: 29,
      estimatedWaitingTime: 45,
      orderMessage: 'Leave at the door',
      createdAt: DateTime.parse("2024-02-15T10:00:00Z"),
      updatedAt: DateTime.parse("2024-02-15T11:00:00Z"),
      orderItems: [
        OrderItemModel(
          id: 'item789',
          itemId: 'item001',
          quantity: 2,
          item: ItemInfoModel(
            name: 'Pizza',
            price: 10,
            imageUrl: 'https://example.com/pizza.jpg',
          ),
        )
      ],
      orderStatus: 'pending',
      orderType: 'delivery',
    );

    test('getOrderHistory should return OrderHistoryModel on success',
        () async {
      final String userId = '123';
      final String status = 'pending';
      final int page = 1;
      final int limit = 10;

      when(mockOrderHistoryDataSource.getOrders(
              userId: userId, status: status, page: page, limit: limit))
          .thenAnswer((_) async => [
                orderHistoryModel,
              ]);

      final result = await orderHistoryRepoImpl.getOrderHistory(
          userId: userId, status: status, page: page, limit: limit);

      expect(result, isA<Right<Failure, List<OrderHistoryModel>>>());
    });

    test('getOrderHistory should return error on failure', () async {
      when(mockOrderHistoryDataSource.getOrders(
              userId: '123', status: 'pending', page: 1, limit: 10))
          .thenThrow(ServerException(errorMessage: 'error'));
      final result = await orderHistoryRepoImpl.getOrderHistory(
          userId: '123', status: 'pending', page: 1, limit: 10);

      expect(result, isA<Left<Failure, List<OrderHistoryModel>>>());

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected a failure, but got success'),
      );
    });
  });

  group('test getOrderDetail', () {
    final OrderDetailModel orderDetailModel = OrderDetailModel(
      id: 'order123',
      restaurantId: 'rest456',
      restaurantName: 'Test Restaurant',
      orderStatus: 'pending',
      orderType: 'delivery',
      totalPrice: 29,
      totalNumberOfItems: 3,
      estimatedWaitingTime: 45,
      orderMessage: 'Leave at the door',
      createdAt: DateTime.parse("2024-02-15T10:00:00Z"),
      updatedAt: DateTime.parse("2024-02-15T11:00:00Z"),
      orderItems: [
        OrderDetailItemEntity(
            id: '1',
            itemId: '123',
            quantity: 12,
            item: OrderItemInfoEntity(name: 'name', price: 21, itemImages: [
              OrderItemImageEntity(url: 'https://exmple.com/history.png')
            ]))
      ],
      orderConfirmedAt: null,
      paymentConfirmedAt: DateTime.parse("2024-02-15T10:30:00Z"),
      orderPlacedAt: DateTime.parse("2024-02-15T10:05:00Z"),
      orderCompletedAt: null,
      orderRejectedAt: null,
    );

    test('getOrderDetail should return OrderDetailModel on success', () async {
      final String orderId = 'order123';

      when(mockOrderHistoryDataSource.getOrderDetail(orderId: orderId))
          .thenAnswer((_) async => orderDetailModel);

      final result =
          await orderHistoryRepoImpl.getOrderDetail(orderId: orderId);

      expect(result, isA<Right<Failure, OrderDetailModel>>());
    });

    test('getOrderDetail should return error on failure', () async {
      when(mockOrderHistoryDataSource.getOrderDetail(orderId: 'order123'))
          .thenThrow(ServerException(errorMessage: 'error'));
      final result =
          await orderHistoryRepoImpl.getOrderDetail(orderId: 'order123');

      expect(result, isA<Left<Failure, OrderDetailModel>>());

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected a failure, but got success'),
      );
    });
  });
}
