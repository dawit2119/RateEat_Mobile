import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_history.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_item_model.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_history/item_info_entity.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/usecases/order_history_usecase.dart';
import 'package:rateeat_mobile/src/features/order_history/presentation/bloc/order_history_list/order_history_bloc.dart';

import 'order_history_bloc_test.mocks.dart';

import 'package:mocktail/mocktail.dart';

class FakeOrderHistoryUseCaseParams extends Fake
    implements OrderHistoryUseCaseParams {}

@GenerateNiceMocks([MockSpec<FetchOrderHistoryUseCase>()])
void main() {
  late OrderHistoryBloc orderHistoryBloc;
  late MockFetchOrderHistoryUseCase mockFetchOrderHistoryUseCase;

  setUp(() async {
    registerFallbackValue(FakeOrderHistoryUseCaseParams());
    mockFetchOrderHistoryUseCase = MockFetchOrderHistoryUseCase();
    orderHistoryBloc = OrderHistoryBloc(
        fetchOrderHistoryUseCase: mockFetchOrderHistoryUseCase);
  });

  tearDown(() {
    orderHistoryBloc.close();
  });

  group('test OrderHistoryBloc', () {
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

    test('emits OrderHistoryInitial on initial state', () async {
      expect(orderHistoryBloc.state, OrderHistoryInitial());
    });

    blocTest<OrderHistoryBloc, OrderHistoryState>(
      'emits [OrderHistoryLoading, OrderHistoryLoaded] when FetchOrderHistory is added for the first page',
      build: () {
        when(() =>
                mockFetchOrderHistoryUseCase(any<OrderHistoryUseCaseParams>()))
            .thenAnswer(
          (_) async => Right([orderHistoryModel]),
        );

        return orderHistoryBloc;
      },
      act: (bloc) => bloc.add(
          FetchOrderHistory(userId: '123', status: 'all', page: 1, limit: 10)),
      expect: () => [
        OrderHistoryLoading(),
        isA<OrderHistoryLoaded>(),
      ],
    );
  });
}
