import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/data/models/total_price_model.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

import 'get_order_total_price_usecase_test.mocks.dart';

// Generate a mock OrderRepository
@GenerateMocks([OrderRepository])
void main() {
  late GetOrderTotalPriceUseCase useCase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    useCase = GetOrderTotalPriceUseCase(orderRepository: mockOrderRepository);
  });

  group('GetOrderTotalPriceUseCase', () {
    final cart = {Item(itemId: '1', itemName: 'Item1', numberOfReviews: 0): 2};
    const totalPrice = TotalPriceModel(totalItems: 2, totalPrice: 100.0);
    final params = GetOrderTotalPriceUseCaseParams(cart: cart);

    test('should return TotalPrice when repository call is successful',
        () async {
      // Arrange
      when(mockOrderRepository.getTotalOrderPrice(any))
          .thenAnswer((_) async => const Right(totalPrice));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, const Right(totalPrice));
      verify(mockOrderRepository.getTotalOrderPrice(cart)).called(1);
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      final failure = ServerFailure();
      when(mockOrderRepository.getTotalOrderPrice(any))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, Left(failure));
      verify(mockOrderRepository.getTotalOrderPrice(cart)).called(1);
    });
  });
}
