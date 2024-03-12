import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/usecases/orders_count_usecase.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/repositories/orders_count_repo.dart';

import 'orders_count_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrdersCountRepo>()])
void main() {
  late FetchOrdersCountUseCase fetchOrdersCountUseCase;
  late MockOrdersCountRepo mockOrdersCountRepo;

  setUp(() {
    mockOrdersCountRepo = MockOrdersCountRepo();
    fetchOrdersCountUseCase =
        FetchOrdersCountUseCase(ordersCountRepo: mockOrdersCountRepo);
  });

  group('test FetchOrdersCountUseCase', () {
    final OrdersCountUseCaseParams params =
        OrdersCountUseCaseParams(userId: '123', status: 'pending');
    test('FetchOrdersCountUseCase should return count', () async {
      final int count = 3;
      when(mockOrdersCountRepo.getOrdersCount(
              userId: params.userId, status: params.status))
          .thenAnswer((_) async => Right(count));

      final result = await fetchOrdersCountUseCase(params);

      expect(result, Right(count));

      verify(mockOrdersCountRepo.getOrdersCount(
              userId: params.userId, status: params.status))
          .called(1);
    });

    test('FetchOrdersCountUseCase should return Left on error', () async {
      when(mockOrdersCountRepo.getOrdersCount(
              userId: params.userId, status: params.status))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));

      final result = await fetchOrdersCountUseCase.call(params);

      expect(result, isA<Left<Failure, int>>());

      verify(mockOrdersCountRepo.getOrdersCount(
              userId: params.userId, status: params.status))
          .called(1);
    });
  });
}
