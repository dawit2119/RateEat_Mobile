import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  group('RestaurantServiceCard Tests', () {
    testWidgets('renders title and info correctly',
        (WidgetTester tester) async {
      // Arrange
      const title = 'Restaurant Title';
      const info = 'Delicious food available';
      const iconPath = 'assets/icons/sample_icon.svg';

      // Act
      await tester.pumpWidget(
        ResponsiveSizer(builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantServiceCard(
                title: title,
                info: info,
                iconPath: iconPath,
              ),
            ),
          );
        }),
      );

      // Assert
      expect(find.text(info), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      // Arrange
      const title = 'Restaurant Title';
      const info = 'Delicious food available';
      const iconPath = 'assets/icons/sample_icon.svg';
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantServiceCard(
              title: title,
              info: info,
              iconPath: iconPath,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RestaurantServiceCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('displays left widget when provided',
        (WidgetTester tester) async {
      // Arrange
      const title = 'Restaurant Title';
      const info = 'Delicious food available';
      const iconPath = 'assets/icons/sample_icon.svg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantServiceCard(
              title: title,
              info: info,
              iconPath: iconPath,
              leftWidget: Icon(Icons.star), // Example left widget
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('does not display divider when showDivider is false',
        (WidgetTester tester) async {
      // Arrange
      const title = 'Restaurant Title';
      const info = 'Delicious food available';
      const iconPath = 'assets/icons/sample_icon.svg';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestaurantServiceCard(
              title: title,
              info: info,
              iconPath: iconPath,
              showDivider: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Divider), findsNothing);
    });
  });
}
