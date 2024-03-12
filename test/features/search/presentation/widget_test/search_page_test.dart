import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/restaurant.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'search_page_test.mocks.dart';
import 'test_data.dart';

class MockUserLocationBloc extends Mock implements UserLocationBloc {}

class MockRestaurantsFilterSearchResultsBloc extends Mock
    implements RestaurantsFilterSearchResultsBloc {}

class MockItemsFilterSearchResultsBloc extends Mock
    implements ItemsFilterSearchResultsBloc {}

class MockSearchPageCubit extends Mock implements SearchPageCubit {}

@GenerateNiceMocks([
  MockSpec<MockUserLocationBloc>(),
  MockSpec<MockRestaurantsFilterSearchResultsBloc>(),
  MockSpec<MockItemsFilterSearchResultsBloc>(),
  MockSpec<MockSearchPageCubit>(),
])
void main() {
  group('RestaurantResultPage Widget Test', () {
    const restaurantsFilterSuccessState = FilterRestaurantsSuccess(
      searchFilteredRestaurants: [],
      hasReachedMax: false,
      status: true,
      selection: RestaurantsFilterState.closest,
      category: 0,
      isFasting: false,
      searchQuery: '',
      location: null,
      maximumPrice: 5000,
      rating: 4,
    );
    const itemsFilterSuccessState = FilterItemsSuccess(
      searchFilteredItems: [],
      hasReachedMax: false,
      status: true,
      selection: ItemsFilterState.closest,
      category: 0,
      isFasting: false,
      searchQuery: '',
      location: null,
      maximumPrice: 5000,
      rating: 4,
    );
    late MockUserLocationBloc mockUserLocationBloc;
    late MockRestaurantsFilterSearchResultsBloc
        mockRestaurantsFilterSearchResultsBloc;
    late MockItemsFilterSearchResultsBloc mockItemsFilterSearchResultsBloc;
    late MockSearchPageCubit mockSearchPageCubit;

    setUp(() {
      dpLocator.reset();
      mockUserLocationBloc = MockMockUserLocationBloc();
      mockRestaurantsFilterSearchResultsBloc =
          MockMockRestaurantsFilterSearchResultsBloc();
      mockItemsFilterSearchResultsBloc = MockMockItemsFilterSearchResultsBloc();
      mockSearchPageCubit = MockMockSearchPageCubit();

      dpLocator.registerFactory<UserLocationBloc>(
        () => mockUserLocationBloc,
      );
      dpLocator.registerFactory<RestaurantsFilterSearchResultsBloc>(
        () => mockRestaurantsFilterSearchResultsBloc,
      );
      dpLocator.registerFactory<ItemsFilterSearchResultsBloc>(
        () => mockItemsFilterSearchResultsBloc,
      );
      dpLocator.registerFactory<SearchPageCubit>(
        () => mockSearchPageCubit,
      );
      dpLocator.registerFactory<MultiChipsCubit>(
        () => MultiChipsCubit(),
      );

      SizeConfig.blockSizeVertical = 8;
      SizeConfig.screenWidth = 1000;
      SizeConfig.screenHeight = 2000;
      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<UserLocationBloc>(
              create: (_) => mockUserLocationBloc,
            ),
            BlocProvider<RestaurantsFilterSearchResultsBloc>(
              create: (_) => mockRestaurantsFilterSearchResultsBloc,
            ),
            BlocProvider<ItemsFilterSearchResultsBloc>(
              create: (_) => mockItemsFilterSearchResultsBloc,
            ),
            BlocProvider<SearchPageCubit>(
              create: (_) => mockSearchPageCubit,
            ),
            BlocProvider<LiveSearchCubit>(
              create: (_) => LiveSearchCubit(),
            ),
            BlocProvider<CategoriesToggleBloc>(
              create: (_) => CategoriesToggleBloc(),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('en', 'US'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: ResponsiveSizer(builder: (context, orientation, screenType) {
              return body;
            }),
          ),
        ),
      );
    }

    testWidgets(
        'Should display loading animation when user location is loading',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(const UserLocationLoading());

      await tester.pumpWidget(makeTestableWidget(const SearchResultPage()));
      expect(
          find.byKey(
            const Key("loadingAnimation"),
          ),
          findsOneWidget);
    });

    testWidgets('Should display error message when user location fails to load',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(
        const UserLocationError(message: "Error"),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const SearchResultPage(),
        ),
      );
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display EmptyResultWidget when location is loaded and filtered restaurant are empty.',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenAnswer(
        (_) => const UserLocationLoaded(
          location: Location(latitude: 0.0, longitude: 0.0),
        ),
      );
      when(mockRestaurantsFilterSearchResultsBloc.state).thenAnswer(
        (_) => restaurantsFilterSuccessState,
      );
      await tester.pumpWidget(
        makeTestableWidget(
          const SearchResultPage(),
        ),
      );
      expect(find.byType(EmptyResultWidget), findsOneWidget);
    });
    testWidgets(
        'Should display EmptyResultWidget when location is loaded and filtered items are empty.',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenAnswer(
        (_) => const UserLocationLoaded(
          location: Location(latitude: 0.0, longitude: 0.0),
        ),
      );
      when(mockRestaurantsFilterSearchResultsBloc.state).thenAnswer(
        (_) => restaurantsFilterSuccessState,
      );
      when(mockItemsFilterSearchResultsBloc.state)
          .thenReturn(itemsFilterSuccessState);
      await tester.pumpWidget(
        makeTestableWidget(
          const SearchResultPage(),
        ),
      );
      expect(find.byType(EmptyResultWidget), findsOneWidget);
    });
    // testWidgets(
    //     'Should display list of restaurants when location is loaded and there are filtered restaurants.',
    //     (WidgetTester tester) async {
    //   when(mockUserLocationBloc.state).thenAnswer(
    //     (_) => const UserLocationLoaded(
    //       location: Location(latitude: 0.0, longitude: 0.0),
    //     ),
    //   );
    //   var restaurants = FilterRestaurantsSuccess(
    //     searchFilteredRestaurants: dummyRestaurants,
    //     hasReachedMax: false,
    //     status: true,
    //     selection: RestaurantsFilterState.closest,
    //     category: 0,
    //     isFasting: false,
    //     searchQuery: '',
    //     location: null,
    //     maximumPrice: 5000,
    //     rating: 4,
    //   );
    //   when(mockRestaurantsFilterSearchResultsBloc.state).thenAnswer(
    //     (_) => restaurants,
    //   );
    //   // Define the URL
    //   const latitude = 9.3;
    //   const longitude = 38.9;
    //   const minRating = 3.0;
    //   const maxPrice = 4000;
    //   const page = 1;
    //   const limit = 10;
    //   final url =
    //       'https://rateeat-backend-ij7jnmwh2q-zf.a.run.app/api/v1/restaurants?latitude=$latitude&longitude=$longitude&radius=20000&page=$page&limit=$limit&sortedBy=distance&minRating=$minRating&maxPrice=$maxPrice';

    //   // Stub the mockDio.get method
    //   when(mockDio.get(url,
    //       queryParameters: anyNamed('queryParameters'),
    //       options: anyNamed('options'),
    //       cancelToken: anyNamed('cancelToken'),
    //       onReceiveProgress: anyNamed('onReceiveProgress')))
    //       .thenAnswer((_) async => Response(
    //     data: restaurantsSortedByDistance,
    //     requestOptions: RequestOptions(path: url),
    //     statusCode: 200,
    //   ));
    //   await tester.pumpWidget(
    //     makeTestableWidget(
    //       const SearchResultPage(),
    //     ),
    //   );
    //   expect(find.byType(RestaurantCard), findsWidgets);
    // });
    // testWidgets('Should handle pagination on restaurant scroll',
    //     (WidgetTester tester) async {
    //   var restaurants = FilterRestaurantsSuccess(
    //     searchFilteredRestaurants: [
    //       ...dummyRestaurants,
    //       ...dummyRestaurants,
    //       ...dummyRestaurants,
    //       ...dummyRestaurants
    //     ],
    //     hasReachedMax: false,
    //     status: true,
    //     selection: RestaurantsFilterState.closest,
    //     category: 0,
    //     isFasting: false,
    //     searchQuery: '',
    //     location: null,
    //     maximumPrice: 5000,
    //     rating: 4,
    //   );
    //   when(mockUserLocationBloc.state).thenAnswer(
    //     (_) => const UserLocationLoaded(
    //       location: Location(latitude: 0.0, longitude: 0.0),
    //     ),
    //   );
    //   when(mockRestaurantsFilterSearchResultsBloc.state).thenAnswer(
    //     (_) => restaurants,
    //   );
    //   when(
    //     mockRestaurantsFilterSearchResultsBloc.add(
    //       const GetFilteredRestaurantEvent(
    //         category: 0,
    //         isFasting: false,
    //         searchQuery: "",
    //         selection: RestaurantsFilterState.closest,
    //         location: Location(
    //           latitude: 9,
    //           longitude: 38,
    //         ),
    //         rating: 5,
    //         maximumPrice: 5000,
    //       ),
    //     ),
    //   ).thenReturn(null);

    //   await tester.pumpWidget(
    //     makeTestableWidget(
    //       const SearchResultPage(),
    //     ),
    //   );
    //   final Finder scrollViewFinder =
    //       find.byKey(const Key('restaurant_scroll'));

    //   await tester.drag(scrollViewFinder, const Offset(0, -500));
    //   await tester.pumpAndSettle();

    //   verify(
    //     mockRestaurantsFilterSearchResultsBloc.add(
    //       const GetFilteredRestaurantEvent(
    //         category: 0,
    //         isFasting: false,
    //         searchQuery: "",
    //         selection: RestaurantsFilterState.closest,
    //         location: Location(
    //           latitude: 9,
    //           longitude: 38,
    //         ),
    //         rating: 5,
    //         maximumPrice: 5000,
    //       ),
    //     ),
    //   ).called(0); //should be 1
    // });
  });
}
