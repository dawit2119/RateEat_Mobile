import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/rating_bar.dart';

void main() {
  testWidgets('CustomRatingBar widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomRatingBar(rating: 3.5),
        ),
      ),
    );

    final ratingBar = tester.firstWidget<RatingBar>(find.byType(RatingBar));
    expect(ratingBar.initialRating, 3.5);

    expect(ratingBar.itemCount, 5);

    expect(ratingBar.itemSize, 15);

    expect(ratingBar.unratedColor, const Color(0xFFDAD9D9));

    expect(ratingBar.glowColor, const Color(0xFFB5BABE));

    expect(ratingBar.glowRadius, 0.1);

    final icon = tester.firstWidget<Icon>(find.byIcon(Icons.star_rounded));
    expect(icon.color, const Color(0xFFFF3008));

    expect(ratingBar.ignoreGestures, true);

    expect(ratingBar.allowHalfRating, true);

    expect(ratingBar.minRating, 1);

    expect(ratingBar.direction, Axis.horizontal);

    expect(ratingBar.itemPadding, const EdgeInsets.only(left: 5));
  });
}
