import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/preview_selected_image.dart';

void main() {
  testWidgets('PreviewImage builds without crashing',
      (WidgetTester tester) async {
    const testImagePath = 'test/path/to/image.jpg';

    await tester.pumpWidget(
      const MaterialApp(
        home: PreviewImage(
          imagePath: testImagePath,
        ),
      ),
    );

    expect(find.byType(PreviewImage), findsOneWidget);
    expect(find.byType(Stack), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.byType(PhotoView), findsOneWidget);
  });
}
