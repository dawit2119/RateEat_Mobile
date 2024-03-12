import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/theme/app_colors.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/custom_text_form_field.dart';

void main() {
  testWidgets('CustomTextFormField widget test', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextFormField(
            hintText: 'Enter text',
            fillColor: Colors.white,
            labelColor: Colors.black,
            controller: controller,
            width: 200,
            leftIcon: Icons.search,
          ),
        ),
      ),
    );

    expect(find.text('Enter text'), findsOneWidget);

    expect(
        find.byWidgetPredicate((widget) =>
            widget is TextFormField && widget.controller == controller),
        findsOneWidget);

    final sizedBox = tester.firstWidget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, 200);

    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
