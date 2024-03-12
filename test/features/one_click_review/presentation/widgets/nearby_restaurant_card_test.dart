import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_restaurant_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'nearby_restaurant_card_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SimpleReviewStepperBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockSimpleReviewStepperBloc mockBloc;
  late MockGoRouter mockRouter;

  setUp(() {
    mockBloc = MockSimpleReviewStepperBloc();
    mockRouter = MockGoRouter();
  });

  testWidgets('NearByRestaurantCard displays correctly',
      (WidgetTester tester) async {
    final mockRestaurant = NearByRestaurantResponse(
      id: '1',
      name: 'Test Restaurant',
      currency: 'USD',
    );

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MediaQuery(
            data:
                const MediaQueryData(size: Size(400, 800)), // Mock screen size
            child: BlocProvider<SimpleReviewStepperBloc>(
              create: (_) => mockBloc,
              child: MaterialApp(
                locale: const Locale('en', 'US'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: Scaffold(
                  body: NearByRestaurantCard(restaurant: mockRestaurant),
                ),
                navigatorKey: GlobalKey<NavigatorState>(),
              ).wrapWithGoRouter(mockRouter),
            ),
          );
        },
      ),
    );

    await tester.pump();

    expect(find.byType(NearByRestaurantCard), findsOneWidget);
    expect(find.text('Test Restaurant'), findsOneWidget);
    expect(find.byIcon(Iconsax.search_normal_1), findsOneWidget);
    expect(find.byIcon(Iconsax.export_3), findsOneWidget);
  });
}

// Helper extension to inject GoRouter
extension GoRouterTestExtension on Widget {
  Widget wrapWithGoRouter(GoRouter router) {
    return InheritedGoRouter(
      goRouter: router,
      child: this,
    );
  }
}
