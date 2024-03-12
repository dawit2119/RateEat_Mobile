import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/restaurant_search_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  group('CustomTextInputField Widget Tests', () {
    testWidgets('renders correctly with given properties',
        (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();

      await tester.pumpWidget(
        ResponsiveSizer(
          builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return MaterialApp(
              home: Scaffold(
                body: CustomTextInputField(
                  hintText: 'Enter text',
                  iconPath: 'assets/icons/sample_icon.svg',
                  controller: controller,
                  fillColor: Colors.white,
                  labelColor: AppColors.grey400,
                  inputType: TextInputType.text,
                  autoFocus: true,
                  showTrailing: true,
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);

      expect(find.byType(SvgPicture), findsAtLeast(1));

      expect(find.byType(TextFormField), findsOneWidget);

      expect(find.byType(GestureDetector), findsAtLeast(1));
    });
  });
}
