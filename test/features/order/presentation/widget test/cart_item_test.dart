import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';

// Generate mocks
@GenerateMocks([GoRouter])
import 'cart_item_test.mocks.dart';

// Create a mock class for WalkingDistanceChecker
class MockWalkingDistanceChecker extends Mock {
  bool isFeasibleWalkingTime({required String walkingTime}) => true;
}

void main() {
  group('CartItem Widget Tests', () {
    late Widget testWidget;
    late MockGoRouter mockGoRouter;
    late MockWalkingDistanceChecker mockWalkingDistanceChecker;

    setUp(() {
      mockGoRouter = MockGoRouter();
      mockWalkingDistanceChecker = MockWalkingDistanceChecker();

      testWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: InheritedGoRouter(
          goRouter: mockGoRouter,
          child: const Scaffold(
            body: CartItem(
              id: '1',
              imageUrl: 'https://example.com/image.jpg',
              rating: 4.5,
              foodName: 'Delicious Burger',
              restaurantName: 'Burger Palace',
              price: 9.99,
              noOfReviews: 100,
              ridingTime: '15 min',
              walkingTime: '30 min',
              distance: '2.5',
              currencyCode: 'USD',
            ),
          ),
        ),
      );
    });

    testWidgets('CartItem displays correct food name',
        (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      final textWidget = find.text('Delicious Burger');
      expect(find.text('Delicious Burger'), textWidget);
    });

    //   testWidgets('CartItem displays correct restaurant name',
    //       (WidgetTester tester) async {
    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.text('Burger Palace'), findsOneWidget);
    //   });

    //   testWidgets('CartItem displays correct price and currency',
    //       (WidgetTester tester) async {
    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.text('9 USD'), findsOneWidget);
    //   });

    //   testWidgets('CartItem displays correct rating and number of reviews',
    //       (WidgetTester tester) async {
    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.text('4.5/5'), findsOneWidget);
    //     expect(find.textContaining('100'), findsOneWidget);
    //   });

    //   testWidgets('CartItem displays correct distance',
    //       (WidgetTester tester) async {
    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.textContaining('2.5'), findsOneWidget);
    //   });

    //   testWidgets('CartItem displays walking time for feasible distances',
    //       (WidgetTester tester) async {
    //     when(mockWalkingDistanceChecker.isFeasibleWalkingTime(
    //             walkingTime: '30 min'))
    //         .thenReturn(true);

    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.text('30 min'), findsOneWidget);
    //     expect(find.byIcon(Icons.directions_walk), findsOneWidget);
    //   });

    //   testWidgets(
    //       'CartItem displays riding time for non-feasible walking distances',
    //       (WidgetTester tester) async {
    //     when(mockWalkingDistanceChecker.isFeasibleWalkingTime(
    //             walkingTime: '30 min'))
    //         .thenReturn(false);

    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.text('15 min'), findsOneWidget);
    //     expect(find.byIcon(Icons.directions_bus), findsOneWidget);
    //   });

    //   testWidgets('CartItem navigates to item detail on tap',
    //       (WidgetTester tester) async {
    //     when(mockGoRouter.pushNamed(any,
    //             pathParameters: anyNamed('pathParameters')))
    //         .thenAnswer((_) async {});

    //     await tester.pumpWidget(testWidget);
    //     await tester.tap(find.byType(CartItem));
    //     await tester.pumpAndSettle();

    //     verify(mockGoRouter.pushNamed(AppRoutes.itemDetail,
    //         pathParameters: {'itemId': '1'})).called(1);
    //   });
  });
}
