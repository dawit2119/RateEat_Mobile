import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_history.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_item_model.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_history/item_info_entity.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/usecases/order_history_usecase.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:rateeat_mobile/src/features/order_history/presentation/bloc/order_history_list/order_history_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/presentation/bloc/order_history_status/order_history_status_bloc.dart';

import 'orders_count_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FetchOrdersCountUseCase>()])
void main() {
  late OrdersCountBloc ordersCountBloc;
  late MockFetchOrdersCountUseCase fetchOrdersCountUseCase;

  setUp(() {
    fetchOrdersCountUseCase = MockFetchOrdersCountUseCase();
    ordersCountBloc =
        OrdersCountBloc(fetchOrdersCountUseCase: fetchOrdersCountUseCase);
  });

  group('test orders count bloc', () {
    final int count = 3;
    blocTest(
      'emits [OrdersCountInitial, OrdersCountLoaded]',
      build: () {
        when(fetchOrdersCountUseCase(any))
            .thenAnswer((_) async => Right(count));
        return ordersCountBloc;
      },
      act: (bloc) =>
          bloc.add(FetchOrdersCount(userId: '123', status: 'pending')),
      expect: () => [
        OrdersCountLoading(),
        OrdersCountLoaded(count: count),
      ],
    );

    blocTest(
      'emits [OrdersCountLoading, OrdersCountError on FetchOrderCount event]',
      build: () {
        when(fetchOrdersCountUseCase(any)).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'error')));
        return ordersCountBloc;
      },
      act: (bloc) =>
          bloc.add(FetchOrdersCount(userId: '123', status: 'pending')),
      expect: () => [OrdersCountLoading(), OrdersCountError(message: 'error')],
    );
  });
}
