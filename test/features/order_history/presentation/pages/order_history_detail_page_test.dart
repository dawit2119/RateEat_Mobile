import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import 'order_history_detail_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<OrderDetailBloc>(),
  MockSpec<OrderHistoryStatusBloc>(),
  MockSpec<PayOrderBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockOrderDetailBloc mockOrderDetailBloc;
  late MockOrderHistoryStatusBloc mockOrderHistoryStatusBloc;
  late MockPayOrderBloc mockPayOrderBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockOrderDetailBloc = MockOrderDetailBloc();
    mockOrderHistoryStatusBloc = MockOrderHistoryStatusBloc();
    mockPayOrderBloc = MockPayOrderBloc();
    mockGoRouter = MockGoRouter();
  });

  Widget createTestWidget() {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<OrderDetailBloc>(create: (_) => mockOrderDetailBloc),
            BlocProvider<OrderHistoryStatusBloc>(
                create: (_) => mockOrderHistoryStatusBloc),
            BlocProvider<PayOrderBloc>(create: (_) => mockPayOrderBloc),
          ],
          child: MaterialApp.router(
            routerDelegate: mockGoRouter.routerDelegate,
            routeInformationParser: mockGoRouter.routeInformationParser,
            routeInformationProvider: mockGoRouter.routeInformationProvider,
            builder: (context, child) {
              return child ?? Container();
            },
          ),
        );
      },
    );
  }

  testWidgets('OrderHistoryDetailPage displays loading state correctly',
      (tester) async {
    when(mockOrderHistoryStatusBloc.state)
        .thenReturn(OrderHistorySocketLoadingState());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Connecting ...'), findsOneWidget);
  });

  testWidgets('Displays error when socket connection fails', (tester) async {
    when(mockOrderHistoryStatusBloc.state).thenReturn(
        OrderHistorySocketFailedState(errorMessage: 'Connection failed'));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Connection failed'), findsOneWidget);
  });

  testWidgets('Displays order status when updated', (tester) async {
    final mockState = OrderHistoryStatusUpdated();

    when(mockOrderDetailBloc.state).thenReturn(mockState);
    when(mockOrderHistoryStatusBloc.state)
        .thenReturn(OrderHistorySocketConnectedState());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Order Created'), findsOneWidget);
  });
}
