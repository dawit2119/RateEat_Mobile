import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cancel_order_bottom_sheet_test.mocks.dart';

@GenerateMocks([CancelOrderBloc])
void main() {
  late CancelOrderBloc cancelOrderBloc;
  late TextEditingController reasonController;

  setUp(() {
    cancelOrderBloc = MockCancelOrderBloc();
    reasonController = TextEditingController();
  });

  // Helper to wrap the widget with necessary setup for tests
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return BlocProvider.value(
              value: cancelOrderBloc,
              child: child,
            );
          },
        ),
      ),
    );
  }

  testWidgets('displays the Cancel Order BottomSheet correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(CancelOrderBottomSheet(
      orderId: "123",
      restaurantId: "456",
    )));

    // Verify Cancel Order title
    expect(find.text('Cancel Order'), findsAtLeast(1));
    // Verify "What is your reason..." text
    expect(find.text("What is your reason for declining this order?"),
        findsOneWidget);

    // Verify the TextFormField for entering a reason
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('handles input in the AddNoteField', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(CancelOrderBottomSheet(
      orderId: "123",
      restaurantId: "456",
    )));

    // Enter text into the reason field
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();

    // Verify the input text in the controller
    expect(reasonController.text, '');
  });

  testWidgets('cancels order with a reason when button pressed',
      (WidgetTester tester) async {
    // Simulate entering reason text
    await tester.pumpWidget(createTestWidget(CancelOrderBottomSheet(
      orderId: "123",
      restaurantId: "456",
    )));

    // Enter a reason into the AddNoteField
    await tester.enterText(
        find.byType(TextFormField), 'Decided to eat somewhere else');
    await tester.pump();

    // Simulate pressing the Cancel Order button
    await tester.tap(find.byKey(Key('cancel_order_button_key')));
    await tester.pump();

    // Verify the cancel order event has been triggered
    verify(() => cancelOrderBloc.add(CancelOrderRequestEvent(
          orderId: '123',
          reason: 'Decided to eat somewhere else',
        ))).called(1);
  });
}
