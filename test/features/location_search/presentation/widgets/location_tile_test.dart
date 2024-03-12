import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/presentation/widgets/location_tile.dart';

void main() {
  testWidgets('renders LocationTile and responds to tap',
      (WidgetTester tester) async {
    // Arrange
    final mockLocation = GoogleAutoCompleteModel(
      description: 'Addis Ababa',
      placeId: '123',
    );

    bool wasTapped = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationTile(
            location: mockLocation,
            onPress: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    // Verify that the location description is displayed
    expect(find.text('Addis Ababa'), findsNWidgets(2));

    // Tap the location tile
    await tester.tap(find.byType(LocationTile));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that the onPress callback was called
    expect(wasTapped, isTrue);
  });

  testWidgets('renders LocationTile with subtitle',
      (WidgetTester tester) async {
    // Arrange
    final mockLocation = GoogleAutoCompleteModel(
      description: 'Addis Ababa',
      placeId: '123',
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationTile(
            location: mockLocation,
            onPress: () {},
          ),
        ),
      ),
    );

    // Verify that the location description is displayed
    expect(find.text('Addis Ababa'), findsNWidgets(2));
  });
}
