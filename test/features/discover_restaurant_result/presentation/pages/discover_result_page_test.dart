import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/discover_restaurant_model.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_state.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_state.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/pages/discover_result_page.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'discover_result_page_test.mocks.dart';

// Mock classes
@GenerateNiceMocks([
  MockSpec<FetchDiscoverRestaurantResultBloc>(),
  MockSpec<DiscoveryStepsBloc>(),
  MockSpec<LiveSearchCubit>(),
  MockSpec<CategoriesToggleBloc>(),
  MockSpec<LocalSearchHistoryBloc>(),
  MockSpec<PopularSearchesBloc>(),
  MockSpec<TransportModeCubit>(),
  MockSpec<UserLocationBloc>(),
  MockSpec<GoRouter>(),
  MockSpec<PriceMultiChipsBlock>(),
  MockSpec<RatingBloc>(),
])
void main() {
  late MockFetchDiscoverRestaurantResultBloc mockDiscoverResultBloc;
  late MockDiscoveryStepsBloc mockDiscoveryStepsBloc;
  late MockLiveSearchCubit mockLiveSearchCubit;
  late MockCategoriesToggleBloc mockCategoriesToggleBloc;
  late MockLocalSearchHistoryBloc mockLocalSearchHistoryBloc;
  late MockPopularSearchesBloc mockPopularSearchesBloc;
  late MockTransportModeCubit mockTransportModeCubit;
  late MockUserLocationBloc mockUserLocationBloc;
  late MockPriceMultiChipsBlock mockPriceMultiChipsBlock;
  late MockRatingBloc mockRatingBloc;

  setUp(() {
    mockDiscoverResultBloc = MockFetchDiscoverRestaurantResultBloc();
    mockDiscoveryStepsBloc = MockDiscoveryStepsBloc();
    mockLiveSearchCubit = MockLiveSearchCubit();
    mockCategoriesToggleBloc = MockCategoriesToggleBloc();
    mockLocalSearchHistoryBloc = MockLocalSearchHistoryBloc();
    mockPopularSearchesBloc = MockPopularSearchesBloc();
    mockTransportModeCubit = MockTransportModeCubit();
    mockUserLocationBloc = MockUserLocationBloc();
    mockPriceMultiChipsBlock = MockPriceMultiChipsBlock();
    mockRatingBloc = MockRatingBloc();
  });

  Widget createWidgetUnderTest() {
    final mockGoRouter = MockGoRouter();

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: mockGoRouter,
      builder: (context, child) {
        return ResponsiveSizer(
          builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return MultiBlocProvider(
              providers: [
                BlocProvider<FetchDiscoverRestaurantResultBloc>.value(
                  value: mockDiscoverResultBloc,
                ),
                BlocProvider<DiscoveryStepsBloc>.value(
                  value: mockDiscoveryStepsBloc,
                ),
                BlocProvider<LiveSearchCubit>.value(
                  value: mockLiveSearchCubit,
                ),
                BlocProvider<CategoriesToggleBloc>.value(
                  value: mockCategoriesToggleBloc,
                ),
                BlocProvider<LocalSearchHistoryBloc>.value(
                  value: mockLocalSearchHistoryBloc,
                ),
                BlocProvider<PopularSearchesBloc>.value(
                  value: mockPopularSearchesBloc,
                ),
                BlocProvider<TransportModeCubit>.value(
                  value: mockTransportModeCubit,
                ),
                BlocProvider<UserLocationBloc>.value(
                  value: mockUserLocationBloc,
                ),
                BlocProvider<PriceMultiChipsBlock>.value(
                  value: mockPriceMultiChipsBlock,
                ),
                BlocProvider<RatingBloc>.value(
                  value: mockRatingBloc,
                ),
              ],
              child: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => const DiscoverResultPage(),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  testWidgets('renders DiscoverResultPage with app bar and categories',
      (WidgetTester tester) async {
    when(mockDiscoverResultBloc.state).thenReturn(DiscoverRestaurantLoaded(
        hasReachedMax: false, discoveredRestaurantResults: []));

    when(mockDiscoveryStepsBloc.state).thenReturn(DiscoverRestaurantState(
        discoverRestaurantProps: DiscoverRestaurantModel()));

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the app bar and categories are rendered
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(DiscoveryCategories), findsOneWidget);
  });

  testWidgets('triggers LoadMoreDiscoverRestaurantResultEvent on scroll',
      (WidgetTester tester) async {
    // Set initial state for the bloc
    when(mockDiscoverResultBloc.state).thenReturn(DiscoverRestaurantLoaded(
        hasReachedMax: false,
        discoveredRestaurantResults: [
          DiscoverRestaurantResultModel(id: "1", items: []),
          DiscoverRestaurantResultModel(id: "2", items: []),
          DiscoverRestaurantResultModel(id: "3", items: []),
          DiscoverRestaurantResultModel(id: "4", items: []),
          DiscoverRestaurantResultModel(id: "5", items: []),
          DiscoverRestaurantResultModel(id: "6", items: []),
          DiscoverRestaurantResultModel(id: "7", items: []),
          DiscoverRestaurantResultModel(id: "8", items: []),
        ]));

    when(mockDiscoveryStepsBloc.state).thenReturn(DiscoverRestaurantState(
        discoverRestaurantProps: DiscoverRestaurantModel()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(Duration(seconds: 20));

    // Simulate scrolling to the bottom
    await tester.scrollUntilVisible(
      find.byKey(const Key('restaurant_discover_card_8')),
      500,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('discover_result_page_scroll_view')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    verify(mockDiscoverResultBloc.add(any)).called(1);
  });

  testWidgets('shows filter bottom sheet when filter button is pressed',
      (WidgetTester tester) async {
    when(mockDiscoverResultBloc.state).thenReturn(DiscoverRestaurantLoaded(
        hasReachedMax: false, discoveredRestaurantResults: []));

    when(mockDiscoveryStepsBloc.state).thenReturn(DiscoverRestaurantState(
        discoverRestaurantProps: DiscoverRestaurantModel()));

    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the filter button
    await tester
        .tap(find.byKey(const Key('discover_result_page_search_filter')));
    await tester.pumpAndSettle();

    // Verify bottom sheet is shown
    expect(find.byType(DiscoverRestaurantFilterBottomSheet), findsOneWidget);
  });
}
