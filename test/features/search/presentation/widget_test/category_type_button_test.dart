import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/category_type_buttons.dart';

void main() {
  testWidgets('CategoryTypeButton renders correctly and responds to tap',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryTypeButton(
            isSelected: true,
            title: 'Test Category',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Category'), findsOneWidget);

    final buttonFinder = find.byType(ElevatedButton);
    final button = tester.widget<ElevatedButton>(buttonFinder);
    final buttonStyle = button.style as ButtonStyle;

    final backgroundColor =
        buttonStyle.backgroundColor?.resolve({MaterialState.selected});
    expect(backgroundColor, AppColors.primaryButtonColor);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(wasPressed, true);
  });
}
