import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

import 'order_detail_usecase_test.mocks.dart';

void main() {
  late FetchOrderHistoryUseCase fetchOrderHistoryUseCase;
  late MockOrderHistoryRepo mockOrderHistoryRepo;

  setUp(() {
    mockOrderHistoryRepo = MockOrderHistoryRepo();
    fetchOrderHistoryUseCase =
        FetchOrderHistoryUseCase(orderHistoryRepo: mockOrderHistoryRepo);
  });

  group('test FetchOrderHistoryUseCase', () {
    final orderHistoryModel = OrderHistoryModel(
      id: '123',
      userId: '123',
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
          item: ItemInfoEntity(
            name: 'Pizza',
            price: 10,
            imageUrl: 'https://example.com/pizza.jpg',
          ),
        ),
      ],
      orderStatus: 'pending',
      orderType: 'delivery',
    );

    final OrderHistoryUseCaseParams params = OrderHistoryUseCaseParams(
      userId: '123',
      status: 'pending',
      page: 1,
      limit: 10,
    );
    test('FetchOrderHistoryUseCase should return OrderHistoryModel on success',
        () async {
      when(mockOrderHistoryRepo.getOrderHistory(
              userId: params.userId,
              status: params.status,
              page: params.page,
              limit: params.limit))
          .thenAnswer((_) async => Right([orderHistoryModel]));

      final result = await fetchOrderHistoryUseCase.call(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (orderList) {
          expect(orderList, hasLength(1));
          expect(orderList.first.id, orderHistoryModel.id);
          expect(orderList.first.userId, orderHistoryModel.userId);
          expect(orderList.first.restaurantId, orderHistoryModel.restaurantId);
        },
      );

      verify(mockOrderHistoryRepo.getOrderHistory(
        userId: params.userId,
        status: params.status,
        page: params.page,
        limit: params.limit,
      )).called(1);
    });

    test('FetchOrderhistoryUsecase should return error on failure', () async {
      final failure = ServerFailure(errorMessage: 'Server Error');
      when(mockOrderHistoryRepo.getOrderHistory(
              userId: params.userId,
              status: params.status,
              page: params.page,
              limit: params.limit))
          .thenAnswer((_) async => Left(failure));

      final result = await fetchOrderHistoryUseCase(params);

      expect(result.fold((l) => Left(l), (r) => null), Left(failure));
    });
  });
}
