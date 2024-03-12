import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/cancel_order/cancel_order_bloc.dart';

import 'cancel_order_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CancelOrderUseCase>(),
])
void main() {
  late CancelOrderBloc cancelOrderBloc;
  late MockCancelOrderUseCase mockCancelOrderUseCase;

  setUp(() {
    mockCancelOrderUseCase = MockCancelOrderUseCase();
    cancelOrderBloc = CancelOrderBloc(
      cancelOrderUseCase: mockCancelOrderUseCase,
    );
  });

  final cancelParams = CancelOrderUseCaseParams(
    orderId: '123',
    reason: 'Changed my mind',
  );

  group('CancelOrderBloc', () {
    test('initial state should be CancelOrderRequestInitial', () {
      expect(cancelOrderBloc.state, CancelOrderRequestInitial());
    });

    group('cancel order', () {
      blocTest<CancelOrderBloc, CancelOrderState>(
        'should emit [CancelOrderRequestLoading, CancelOrderRequestSuccess] when CancelOrderRequestEvent is successful',
        build: () {
          final cancelParam = CancelOrderUseCaseParams(
            orderId: '123',
            reason: 'Changed my mind',
          );
          final bloc = CancelOrderBloc(
            cancelOrderUseCase: mockCancelOrderUseCase,
          );
          when(mockCancelOrderUseCase(any))
              .thenAnswer((_) async => const Right(true));
          return bloc;
        },
        act: (bloc) async => bloc.add(CancelOrderRequestEvent(
          orderId: '123',
          reason: 'Changed my mind',
        )),
        expect: () => [
          isA<CancelOrderRequestLoading>(),
          isA<CancelOrderRequestSuccess>(),
        ],
      );

      blocTest<CancelOrderBloc, CancelOrderState>(
        'should emit [CancelOrderRequestLoading, CancelOrderRequestFailed] when CancelOrderRequestEvent fails.',
        build: () {
          when(mockCancelOrderUseCase(any)).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: "Server Error")));

          return cancelOrderBloc;
        },
        act: (bloc) => bloc.add(CancelOrderRequestEvent(
          orderId: '123',
          reason: 'Changed my mind',
        )),
        expect: () => <CancelOrderState>[
          CancelOrderRequestLoading(),
          const CancelOrderRequestFailed(errorMessage: "Server Error"),
        ],
      );

      blocTest<CancelOrderBloc, CancelOrderState>(
        'should emit [CancelOrderRequestLoading, CancelOrderRequestFailed] when an exception occurs.',
        build: () {
          when(
            mockCancelOrderUseCase.call(any),
          ).thenThrow(Exception('Something went wrong'));
          return cancelOrderBloc;
        },
        act: (bloc) => bloc.add(CancelOrderRequestEvent(
          orderId: cancelParams.orderId,
          reason: cancelParams.reason,
        )),
        expect: () => <CancelOrderState>[
          CancelOrderRequestLoading(),
          const CancelOrderRequestFailed(
              errorMessage: "Unable to cancel order"),
        ],
      );
    });
  });
}
