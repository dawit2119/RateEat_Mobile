import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'discover_screen_test.mocks.dart';

class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    required this.goRouter,
    required this.child,
    super.key,
  });

  final MockGoRouter goRouter;

  final Widget child;

  @override
  Widget build(BuildContext context) => InheritedGoRouter(
        goRouter: goRouter,
        child: child,
      );
}

// Mock Blocs
@GenerateNiceMocks([
  MockSpec<UserLocationBloc>(),
  MockSpec<SelectFoodCategoryBloc>(),
  MockSpec<DiscoveryStepsBloc>(),
  MockSpec<AllRestaurantsBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockUserLocationBloc mockUserLocationBloc;
  late MockSelectFoodCategoryBloc mockSelectFoodCategoryBloc;
  late MockDiscoveryStepsBloc mockDiscoveryStepsBloc;
  late MockAllRestaurantsBloc mockAllRestaurantsBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockUserLocationBloc = MockUserLocationBloc();
    mockSelectFoodCategoryBloc = MockSelectFoodCategoryBloc();
    mockDiscoveryStepsBloc = MockDiscoveryStepsBloc();
    mockAllRestaurantsBloc = MockAllRestaurantsBloc();
    mockGoRouter = MockGoRouter();

    // Set default states
    when(mockUserLocationBloc.state).thenReturn(UserLocationInitial());
    when(mockGoRouter.pop()).thenReturn(null);
  });

  // Helper widget creating function for testing
  Widget createDiscoverScreen() {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      SizeConfig().init(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserLocationBloc>.value(value: mockUserLocationBloc),
          BlocProvider<SelectFoodCategoryBloc>.value(
              value: mockSelectFoodCategoryBloc),
          BlocProvider<DiscoveryStepsBloc>.value(value: mockDiscoveryStepsBloc),
          BlocProvider<AllRestaurantsBloc>.value(value: mockAllRestaurantsBloc),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MockGoRouterProvider(
            goRouter: mockGoRouter,
            child: const DiscoverScreen(),
          ),
        ),
      );
    });
  }

  group('DiscoverScreen', () {
    testWidgets('renders basic UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createDiscoverScreen());

      // Check for title
      expect(find.text('What do you want to do today?'), findsOneWidget);

      // Check for discover cards
      expect(find.byType(DiscoverCard), findsNWidgets(2));
    });

    testWidgets('initial state triggers GetUserLocation event',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(UserLocationInitial());
      await tester.pumpWidget(createDiscoverScreen());
      // Verify that GetUserLocation event is added
      verify(mockUserLocationBloc.add(const GetUserLocation())).called(1);
    });

    testWidgets('first discover card behavior when location is loaded',
        (WidgetTester tester) async {
      // Mock location loaded state
      when(mockUserLocationBloc.state)
          .thenReturn(const UserLocationLoaded(location: testLocation));

      await tester.pumpWidget(createDiscoverScreen());
      await tester.pumpAndSettle();

      // Find and tap the first discover card
      final firstCardFinder = find.byWidgetPredicate(
        (widget) =>
            widget is DiscoverCard && widget.title == 'Choose restaurant',
      );

      await tester.tap(firstCardFinder);
      await tester.pumpAndSettle();

      // Verify events are dispatched
      verify(mockSelectFoodCategoryBloc.add(ResetCategoryEvent())).called(1);
      verify(mockDiscoveryStepsBloc.add(const StartDiscoverFlowEvent()))
          .called(1);
      verify(mockAllRestaurantsBloc.add(ResetAllRestaurantsEvent())).called(1);
    });

    testWidgets('first discover card behavior when location is not loaded',
        (WidgetTester tester) async {
      // Mock initial location state
      when(mockUserLocationBloc.state).thenReturn(const UserLocationInitial());

      await tester.pumpWidget(createDiscoverScreen());
      await tester.pumpAndSettle();

      // Find and tap the first discover card
      final firstCardFinder = find.byWidgetPredicate(
        (widget) =>
            widget is DiscoverCard && widget.title == 'Choose restaurant',
      );

      await tester.tap(firstCardFinder);
      await tester.pumpAndSettle();
      await tester.pump(Duration(milliseconds: 2000));

      // Verify GetUserLocation event is dispatched
      verify(mockUserLocationBloc.add(const GetUserLocation())).called(2);
    });

    testWidgets('second discover card navigates to search page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDiscoverScreen());
      await tester.pumpAndSettle();

      // Find and tap the second discover card
      final secondCardFinder = find.byWidgetPredicate(
        (widget) =>
            widget is DiscoverCard && widget.title == 'Explore the menu',
      );

      await tester.tap(secondCardFinder);
      await tester.pumpAndSettle();
    });
  });
}

// Mock data for testing
const testLocation = Location(
  latitude: 40.7128,
  longitude: -74.0060,
);
