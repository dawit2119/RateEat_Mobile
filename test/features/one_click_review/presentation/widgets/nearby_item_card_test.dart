import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_item_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:iconsax/iconsax.dart';

import 'nearby_item_card_test.mocks.dart';

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

  testWidgets('NearByItemCard displays correctly', (WidgetTester tester) async {
    final mockItem = NearByItemResponse(
      id: '1',
      name: 'Test Item',
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
                home: Scaffold(
                  body: NearByItemCard(item: mockItem),
                ),
                navigatorKey: GlobalKey<NavigatorState>(),
              ).wrapWithGoRouter(
                  mockRouter), // Custom extension to inject router
            ),
          );
        },
      ),
    );

    await tester.pump();

    expect(find.byType(NearByItemCard), findsOneWidget);
    expect(find.text('Test Item'), findsOneWidget);
    expect(find.byIcon(Iconsax.search_normal_1), findsOneWidget);
    expect(find.byIcon(Iconsax.export_3), findsOneWidget);
  });

  testWidgets('NearByItemCard calls onTap and navigates to item detail',
      (WidgetTester tester) async {
    final mockItem = NearByItemResponse(
      id: '1',
      name: 'Test Item',
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
                home: Scaffold(
                  body: NearByItemCard(item: mockItem),
                ),
                navigatorKey: GlobalKey<NavigatorState>(),
              ).wrapWithGoRouter(
                  mockRouter), // Custom extension to inject router
            ),
          );
        },
      ),
    );

    await tester.pump();

    await tester.tap(find.byIcon(Iconsax.export_3));
    await tester.pump();

    verify(mockRouter.pushNamed(
      AppRoutes.itemDetail,
      pathParameters: {'itemId': '1'},
    )).called(1);
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
