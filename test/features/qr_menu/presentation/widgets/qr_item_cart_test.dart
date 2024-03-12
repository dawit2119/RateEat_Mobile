import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class _EnableHttpOverrides extends HttpOverrides {}

void main() {
  testWidgets('QRItemCard displays item details', (WidgetTester tester) async {
    HttpOverrides.global = _EnableHttpOverrides();
    // Prepare the mock item
    final item = QRItemModel(
      id: '1',
      name: 'Test Item',
      imageUrl: 'https://picsum.photos/200',
      rating: 4.5,
      numberOfReviews: 10,
      price: 100,
      categoryId: 'category id',
      isFasting: false,
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveSizer(
          builder: (context, orientation, type) {
            return QRItemCard(item: item);
          },
        ),
      ),
    );
    await tester.pump(Duration(seconds: 1));

    // Verify that the item details are displayed correctly
    expect(find.text('Test Item'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(10 reviews)'), findsOneWidget);
    expect(find.text('100 Birr'), findsOneWidget);
  });
}
