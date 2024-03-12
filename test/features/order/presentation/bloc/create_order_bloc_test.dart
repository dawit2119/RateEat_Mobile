import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/data/models/order_model.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/create_order/create_order_bloc.dart';

import 'create_order_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CreateOrderUseCase>(),
])
void main() {
  late CreateOrderBloc createOrderBloc;
  late MockCreateOrderUseCase mockCreateOrderUseCase;

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    createOrderBloc =
        CreateOrderBloc(createOrderUseCase: mockCreateOrderUseCase);
  });

  tearDown(() {
    createOrderBloc.close();
  });

  final orderModel = OrderModel(
    id: '1',
    orderItems: const [], // Add relevant items here
    totalPrice: 100.0,
    totalNumberOfItems: 5,
    orderStatus: 'Pending',
    orderType: 'Dine-in',
    estimatedWaitingTime: 30,
    orderMessage: 'Test Message',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final createOrderParams = CreateOrderUseCaseParams(order: orderModel);

  group('CreateOrderBloc', () {
    test('initial state should be CreateOrderInitial', () {
      expect(createOrderBloc.state, CreateOrderInitial());
    });

    group('Create Order', () {
      blocTest<CreateOrderBloc, CreateOrderState>(
        'should emit [CreateOrderActionsLoading, CreateOrderCreated] when the order creation is successful',
        build: () {
          when(mockCreateOrderUseCase.call(any))
              .thenAnswer((_) async => Right(OrderEntity(
                    id: '1',
                    totalNumberOfItems: 5,
                    totalPrice: 100.0,
                    orderStatus: 'Pending',
                    orderType: 'Dine-in',
                    estimatedWaitingTime: 30,
                    orderMessage: 'Test Message',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    orderItems: const [],
                  )));
          return createOrderBloc;
        },
        act: (bloc) => bloc.add(CreateNewOrderEvent(order: orderModel)),
        expect: () => <CreateOrderState>[
          CreateOrderActionsLoading(),
          CreateOrderCreated(
            orderStatus: OrderEntity(
              id: '1',
              totalNumberOfItems: 5,
              totalPrice: 100.0,
              orderStatus: 'Pending',
              orderType: 'Dine-in',
              estimatedWaitingTime: 30,
              orderMessage: 'Test Message',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              orderItems: const [],
            ), // Create a valid instance of CreateOrderCreated
          ),
        ],
      );

      blocTest<CreateOrderBloc, CreateOrderState>(
        'should emit [CreateOrderActionsLoading, CreateOrderActionsFailed] when order creation fails',
        build: () {
          when(mockCreateOrderUseCase.call(any)).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: "Server Error")),
          );
          return createOrderBloc;
        },
        act: (bloc) => bloc.add(CreateNewOrderEvent(order: orderModel)),
        expect: () => <CreateOrderState>[
          CreateOrderActionsLoading(),
          const CreateOrderActionsFailed(errorMessage: "Server Error"),
        ],
      );

      blocTest<CreateOrderBloc, CreateOrderState>(
        'should emit [CreateOrderActionsLoading, CreateOrderActionsFailed] when an exception occurs',
        build: () {
          when(mockCreateOrderUseCase.call(createOrderParams))
              .thenThrow(Exception('Something went wrong'));
          return createOrderBloc;
        },
        act: (bloc) => bloc.add(CreateNewOrderEvent(order: orderModel)),
        expect: () => <CreateOrderState>[
          CreateOrderActionsLoading(),
          const CreateOrderActionsFailed(
              errorMessage: "Unable to create order"),
        ],
      );
    });
  });
}
