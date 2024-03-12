import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/restaurant_info.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant.dart';

void main() {
  testWidgets('RestaurantInfo widget test', (WidgetTester tester) async {
    final restaurant = Restaurant(name: 'Test Restaurant Name');

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantInfo(restaurant: restaurant),
            ),
          );
        },
      ),
    );

    expect(find.text('Test Restaurant Name'), findsOneWidget);

    final textWidget = tester.firstWidget<Text>(find.byType(Text));
    expect(textWidget.style?.fontSize, 16.sp);
    expect(textWidget.style?.fontWeight, FontWeight.bold);
    expect(textWidget.maxLines, 3);

    final container = tester.firstWidget<Container>(find.byType(Container));
    expect(container.color, Colors.white);

    expect(container.padding, const EdgeInsets.all(16.0));

    final row = tester.firstWidget<Row>(find.byType(Row));
    expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);

    expect(row.crossAxisAlignment, CrossAxisAlignment.start);

    final sizedBox = tester.firstWidget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, 5);
  });
}
