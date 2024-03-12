import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/add_note_section.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return child;
          },
        ),
      ),
    );
  }

  testWidgets('displays the title correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(AddNoteField(
      title: "Test Title",
      hintText: "Enter note here",
      textEditingController: controller,
    )));

    expect(find.text("Test Title"), findsOneWidget);
  });

  testWidgets('allows text input', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(AddNoteField(
      title: "Test Title",
      hintText: "Enter note here",
      textEditingController: controller,
    )));

    await tester.enterText(find.byType(TextFormField), "New note text");

    expect(controller.text, "New note text");
  });

  testWidgets('uses the correct controller', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(AddNoteField(
      title: "Test Title",
      hintText: "Enter note here",
      textEditingController: controller,
    )));

    expect(find.byType(TextFormField), findsOneWidget);
  });
}
