import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/order/data/data.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/pay_order/order_bloc.dart';

import 'pay_order_bloc_test.mocks.dart';

@GenerateMocks([PayOrderUseCase])
void main() {
  late PayOrderBloc payOrderBloc;
  late MockPayOrderUseCase mockPayOrderUseCase;

  setUp(() {
    mockPayOrderUseCase = MockPayOrderUseCase();
    payOrderBloc = PayOrderBloc(payOrderUseCase: mockPayOrderUseCase);
  });

  const paymentInfo = PaymentRequestModel(
    orderId: '123', // Add the required orderId
    firstName: 'John', // Add the required firstName
    lastName: 'Doe', // Add the required lastName
    email: 'john.doe@example.com',
    phoneNumber: '123-456-7890',
  );

  final paymentParams = PaymentRequestUseCaseParams(paymentInfo: paymentInfo);
  const testUrl = "https://testpayment.com/redirect";

  group('PayOrderBloc', () {
    test('initial state should be PaymentOrderInitial', () {
      expect(payOrderBloc.state, PaymentOrderInitial());
    });

    blocTest<PayOrderBloc, PayOrderState>(
      'emits [PaymentOrderActionsLoading, PaymentOrderCreated] on successful payment URL retrieval',
      build: () {
        when(mockPayOrderUseCase(any))
            .thenAnswer((_) async => const Right(testUrl));
        return payOrderBloc;
      },
      act: (bloc) =>
          bloc.add(const CreatePaymentOrderEvent(paymentInfo: paymentInfo)),
      expect: () => <PayOrderState>[
        PaymentOrderActionsLoading(),
        const PaymentOrderCreated(returnUrl: testUrl),
      ],
    );

    blocTest<PayOrderBloc, PayOrderState>(
      'emits [PaymentOrderActionsLoading, PaymentOrderActionsFailed] on payment URL retrieval failure',
      build: () {
        when(mockPayOrderUseCase(any)).thenAnswer((_) async =>
            Left(ServerFailure(errorMessage: "Payment service error")));
        return payOrderBloc;
      },
      act: (bloc) =>
          bloc.add(const CreatePaymentOrderEvent(paymentInfo: paymentInfo)),
      expect: () => <PayOrderState>[
        PaymentOrderActionsLoading(),
        const PaymentOrderActionsFailed(errorMessage: "Payment service error"),
      ],
    );

    blocTest<PayOrderBloc, PayOrderState>(
      'emits [PaymentOrderActionsLoading, PaymentOrderActionsFailed] when an exception is thrown',
      build: () {
        when(mockPayOrderUseCase(paymentParams))
            .thenThrow(Exception("Unexpected error"));
        return payOrderBloc;
      },
      act: (bloc) =>
          bloc.add(const CreatePaymentOrderEvent(paymentInfo: paymentInfo)),
      expect: () => <PayOrderState>[
        PaymentOrderActionsLoading(),
        const PaymentOrderActionsFailed(
            errorMessage: "Unable to get payment url"),
      ],
    );
  });
}
