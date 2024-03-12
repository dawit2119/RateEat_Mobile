import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/order_history_data_source.dart';
import 'package:rateeat_mobile/src/features/order_history/data/repositories/orders_count_repo_impl.dart';

import 'orders_count_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderHistoryDataSource>()])
void main() {
  late OrdersCountRepoImpl ordersCountRepoImpl;
  late MockOrderHistoryDataSource mockOrderHistoryDataSource;

  setUp(() {
    mockOrderHistoryDataSource = MockOrderHistoryDataSource();
    ordersCountRepoImpl =
        OrdersCountRepoImpl(orderHistoryDataSource: mockOrderHistoryDataSource);
  });

  group('test getOrdersCount', () {
    final String userId = '123';
    final String status = 'pending';
    final int page = 1;
    final int limit = 10;

    test('getOrdersCount should return number on success', () async {
      when(mockOrderHistoryDataSource.getPendingOrdersCount(
              userId: userId, status: status))
          .thenAnswer((_) async => 1);

      final result = await ordersCountRepoImpl.getOrdersCount(
          userId: userId, status: status);

      expect(result, Right(1));
    });

    test('getOrdersCount should return left on error', () async {
      when(mockOrderHistoryDataSource.getPendingOrdersCount(
              userId: userId, status: status))
          .thenAnswer(
              (_) async => throw ServerException(errorMessage: 'error'));

      final result = await ordersCountRepoImpl.getOrdersCount(
          userId: userId, status: status);

      expect(result, Left(ServerFailure(errorMessage: 'error')));
    });
  });
}
