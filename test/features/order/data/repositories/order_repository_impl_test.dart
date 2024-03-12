import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/data/data_sources/order_data_source.dart';
import 'package:rateeat_mobile/src/features/order/data/models/order_model.dart';
import 'package:rateeat_mobile/src/features/order/data/models/payment_request_model.dart';
import 'package:rateeat_mobile/src/features/order/data/repositories/order_repository_impl.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/order_entity.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/total_price.dart';

import 'order_repository_impl_test.mocks.dart';

@GenerateMocks([OrderDataSource])
void main() {
  late OrderRepositoryImpl repository;
  late MockOrderDataSource mockOrderDataSource;

  setUp(() {
    mockOrderDataSource = MockOrderDataSource();
    repository = OrderRepositoryImpl(orderDataSource: mockOrderDataSource);
  });

  group('test getTotalOrderPrice', () {
    final testCart = {
      Item(itemId: '1', itemName: 'TestItem', numberOfReviews: 0): 2
    };
    const testTotalPrice = TotalPrice(totalItems: 2, totalPrice: 50.0);

    test('getTotalOrderPrice returns Right(TotalPrice) on success', () async {
      when(mockOrderDataSource.getTotalPrice(testCart))
          .thenAnswer((_) async => testTotalPrice);

      final result = await repository.getTotalOrderPrice(testCart);

      expect(result, const Right(testTotalPrice));
      verify(mockOrderDataSource.getTotalPrice(testCart)).called(1);
    });

    test('getTotalOrderPrice returns Left(Failure) on error', () async {
      when(mockOrderDataSource.getTotalPrice(testCart))
          .thenThrow(ServerException());

      final result = await repository.getTotalOrderPrice(testCart);

      expect(result, isA<Left<Failure, TotalPrice>>());
      verify(mockOrderDataSource.getTotalPrice(testCart)).called(1);
    });
  });

  group('test createOrder', () {
    final testOrderModel = OrderModel(
      id: '123',
      restaurantId: 'res-1',
      restaurantName: 'Test Restaurant',
      orderStatus: 'Pending',
      orderType: 'Dine-in',
      totalPrice: 100.0,
      totalNumberOfItems: 5,
      estimatedWaitingTime: 30,
      orderMessage: 'Test Message',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      orderItems: const [],
    );
    test('createOrder returns Right(OrderEntity) on success', () async {
      when(mockOrderDataSource.createOrder(testOrderModel))
          .thenAnswer((_) async => testOrderModel);

      final result = await repository.createOrder(testOrderModel);

      expect(result, Right(testOrderModel));
      verify(mockOrderDataSource.createOrder(testOrderModel)).called(1);
    });

    test('createOrder returns Left(Failure) on error', () async {
      when(mockOrderDataSource.createOrder(testOrderModel))
          .thenThrow(ServerException());

      final result = await repository.createOrder(testOrderModel);

      expect(result, isA<Left<Failure, OrderEntity>>());
      verify(mockOrderDataSource.createOrder(testOrderModel)).called(1);
    });
  });

  group('test pay', () {
    final testPaymentInfo = PaymentRequestModel(
      orderId: '123',
      firstName: 'John',
      lastName: 'Doe',
    );
    final testReturnUrl = 'https://payment.return.url';
    test('pay returns Right(String) on success', () async {
      when(mockOrderDataSource.pay(paymentInfo: testPaymentInfo))
          .thenAnswer((_) async => testReturnUrl);

      final result = await repository.pay(paymentInfo: testPaymentInfo);

      expect(result, Right(testReturnUrl));
      verify(mockOrderDataSource.pay(paymentInfo: testPaymentInfo)).called(1);
    });

    test('pay should return Left on error ', () async {
      when(mockOrderDataSource.pay(paymentInfo: testPaymentInfo))
          .thenThrow(ServerException(errorMessage: 'error'));

      final result = await repository.pay(paymentInfo: testPaymentInfo);
      expect(result, Left(ServerFailure(errorMessage: 'error')));
      verify(mockOrderDataSource.pay(paymentInfo: testPaymentInfo)).called(1);
    });
  });

  group('test cancelOrder', () {
    final testOrderId = '123';
    final testReason = 'User canceled';
    final cancelResponse = true;
    test('cancelOrder returns Right(bool) on success', () async {
      when(mockOrderDataSource.cancelOrder(
              orderId: testOrderId, reason: testReason))
          .thenAnswer((_) async => cancelResponse);

      final result = await repository.cancelOrder(
        orderId: testOrderId,
        reason: testReason,
      );

      expect(result, Right(cancelResponse));
      verify(mockOrderDataSource.cancelOrder(
        orderId: testOrderId,
        reason: testReason,
      )).called(1);
    });

    test('cancelOrder should return Left on error', () async {
      const testOrderId = '123';
      const testReason = 'User canceled';

      // Arrange
      when(mockOrderDataSource.cancelOrder(
              orderId: testOrderId, reason: testReason))
          .thenThrow(ServerException(errorMessage: 'error'));

      // Act
      final result = await repository.cancelOrder(
          orderId: testOrderId, reason: testReason);

      // Assert
      expect(result, Left(ServerFailure(errorMessage: 'error')));
      verify(mockOrderDataSource.cancelOrder(
              orderId: testOrderId, reason: testReason))
          .called(1);
    });
  });

  group('test getOrderStatus', () {
    final testOrderId = '123';
    final testOrderModel = OrderModel(
      id: '123',
      restaurantId: 'res-1',
      restaurantName: 'Test Restaurant',
      orderStatus: 'Pending',
      orderType: 'Dine-in',
      totalPrice: 100.0,
      totalNumberOfItems: 5,
      estimatedWaitingTime: 30,
      orderMessage: 'Test Message',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      orderItems: const [],
    );
    test('getOrderStatus returns Right(OrderModel) on success', () async {
      when(mockOrderDataSource.getOrderStatus(orderId: testOrderId))
          .thenAnswer((_) async => testOrderModel);

      final result = await repository.getOrderStatus(orderId: testOrderId);

      expect(result, Right(testOrderModel));
      verify(mockOrderDataSource.getOrderStatus(orderId: testOrderId))
          .called(1);
    });

    test('getOrderStatus should return Left on error', () async {
      when(mockOrderDataSource.getOrderStatus(orderId: testOrderId))
          .thenThrow(ServerException(errorMessage: 'error'));

      final result = await repository.getOrderStatus(orderId: testOrderId);

      expect(result, Left(ServerFailure(errorMessage: 'error')));
      verify(mockOrderDataSource.getOrderStatus(orderId: testOrderId))
          .called(1);
    });
  });
}
