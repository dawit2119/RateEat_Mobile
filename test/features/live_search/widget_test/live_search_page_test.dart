import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/core/dp_injection/dp_injection.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_state.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_state.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_state.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/widgets/widgets.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'live_search_page_test.mocks.dart';

List<ItemModel> dummyItems = [
  ItemModel(
    itemId: "1",
    itemName: "Margherita Pizza",
    numberOfReviews: 112,
    averageRating: 4.5,
    description:
        "Classic Margherita with homemade tomato sauce and mozzarella cheese.",
    restaurantName: "The Italian Corner",
    price: 8.99,
    imageUrl: "margherita_pizza.jpg",
    itemImages: const [ItemMedia(id: "1", url: "margherita_pizza.jpg")],
    itemVideos: const [],
    tags: const ["Vegetarian", "Pizza"],
    categoryId: "1",
    fasting: false,
    createdAt: DateTime(2023, 1, 15),
    updatedAt: DateTime(2023, 1, 20),
    ingredients: const [],
    categories: const Categories(id: "1", name: "Italian", menuId: "1"),
    minutes: 15,
    isOpen: true,
    isFavorite: false,
    distance: "2.3 km",
    walkingTime: "30 mins",
    ridingTime: "10 mins",
  ),
  ItemModel(
    itemId: "2",
    itemName: "Vegan Burger",
    numberOfReviews: 85,
    averageRating: 4.8,
    description:
        "A delicious, fully vegan burger made with a beet and quinoa patty.",
    restaurantName: "Vegan Diner",
    price: 10.50,
    imageUrl: "vegan_burger.jpg",
    itemImages: const [ItemMedia(id: "1", url: "vegan_burger.jpg")],
    itemVideos: const [],
    tags: const ["Vegan", "Burger"],
    categoryId: "2",
    fasting: false,
    createdAt: DateTime(2023, 2, 10),
    updatedAt: DateTime(2023, 2, 15),
    ingredients: const [],
    categories: const Categories(id: "2", name: "Vegan", menuId: "2"),
    minutes: 10,
    isOpen: true,
    isFavorite: true,
    distance: "1.5 km",
    walkingTime: "20 mins",
    ridingTime: "5 mins",
  ),
  ItemModel(
    itemId: "3",
    itemName: "Spicy Ramen",
    numberOfReviews: 150,
    averageRating: 4.7,
    description:
        "Authentic Japanese ramen with a spicy kick, served with soft-boiled egg and bamboo shoots.",
    restaurantName: "Tokyo Ramen House",
    price: 12.99,
    imageUrl: "spicy_ramen.jpg",
    itemImages: const [ItemMedia(id: "1", url: "spicy_ramen.jpg")],
    itemVideos: const [],
    tags: const ["Spicy", "Noodles", "Japanese"],
    categoryId: "3",
    fasting: false,
    createdAt: DateTime(2023, 3, 5),
    updatedAt: DateTime(2023, 3, 10),
    ingredients: const [],
    categories: const Categories(id: "3", name: "Japanese", menuId: "3"),
    minutes: 20,
    isOpen: true,
    isFavorite: true,
    distance: "3 km",
    walkingTime: "40 mins",
    ridingTime: "12 mins",
  ),
  ItemModel(
    itemId: "4",
    itemName: "Chicken Biryani",
    numberOfReviews: 200,
    averageRating: 4.9,
    description:
        "Aromatic basmati rice cooked with tender pieces of chicken and traditional spices.",
    restaurantName: "Indian Spice Emporium",
    price: 11.50,
    imageUrl: "chicken_biryani.jpg",
    itemImages: const [ItemMedia(id: "1", url: "chicken_biryani.jpg")],
    itemVideos: const [],
    tags: const ["Rice", "Indian", "Spicy"],
    categoryId: "4",
    fasting: false,
    createdAt: DateTime(2023, 4, 1),
    updatedAt: DateTime(2023, 4, 6),
    ingredients: const [],
    categories: const Categories(id: "4", name: "Indian", menuId: "4"),
    minutes: 30,
    isOpen: true,
    isFavorite: false,
    distance: "5 km",
    walkingTime: "1 hour",
    ridingTime: "15 mins",
  ),
  ItemModel(
    itemId: "5",
    itemName: "Caesar Salad",
    numberOfReviews: 75,
    averageRating: 4.3,
    description:
        "Crisp romaine lettuce, Parmesan cheese, and croutons, dressed with lemon-anchovy dressing.",
    restaurantName: "Green Leaf Bistro",
    price: 7.99,
    imageUrl: "caesar_salad.jpg",
    itemImages: const [ItemMedia(id: "1", url: "caesar_salad.jpg")],
    itemVideos: const [],
    tags: const ["Salad", "Healthy", "Vegetarian"],
    categoryId: "5",
    fasting: true,
    createdAt: DateTime(2023, 5, 20),
    updatedAt: DateTime(2023, 5, 25),
    ingredients: const [],
    categories: const Categories(id: "5", name: "Salads", menuId: "5"),
    minutes: 10,
    isOpen: true,
    isFavorite: true,
    distance: "1 km",
    walkingTime: "15 mins",
    ridingTime: "5 mins",
  ),
];

@GenerateNiceMocks([
  MockSpec<UserLocationBloc>(),
  MockSpec<SearchBloc>(),
  MockSpec<CategoriesToggleBloc>(),
  MockSpec<LocalSearchHistoryBloc>(),
  MockSpec<RestaurantsFilterSearchResultsBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<PopularSearchesBloc>(),
])
void main() {
  late MockUserLocationBloc mockUserLocationBloc;
  late MockSearchBloc mockSearchBloc;
  late MockCategoriesToggleBloc mockCategoriesToggleBloc;
  late MockLocalSearchHistoryBloc mockLocalSearchHistoryBloc;
  late MockRestaurantsFilterSearchResultsBloc
      mockRestaurantsFilterSearchResultsBloc;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late MockPopularSearchesBloc mockPopularSearchesBloc;

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
  setUp(() async {
    mockUserLocationBloc = MockUserLocationBloc();
    mockSearchBloc = MockSearchBloc();
    mockCategoriesToggleBloc = MockCategoriesToggleBloc();
    mockLocalSearchHistoryBloc = MockLocalSearchHistoryBloc();
    mockRestaurantsFilterSearchResultsBloc =
        MockRestaurantsFilterSearchResultsBloc();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    mockPopularSearchesBloc = MockPopularSearchesBloc();

    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
      () => mockAuthenticationLocalSource,
    );

    when(mockAuthenticationLocalSource.getUserCredential())
        .thenReturn(LocalUserModel(token: "mock token"));

    when(mockUserLocationBloc.state).thenReturn(
      const UserLocationLoaded(
        location: Location(
          latitude: 9,
          longitude: 38,
        ),
      ),
    );
    when(mockSearchBloc.state).thenReturn(SearchInitial());
    when(mockCategoriesToggleBloc.state).thenReturn(0);
    when(mockLocalSearchHistoryBloc.state).thenReturn(
      LocalSearchHistoryInitialState(),
    );
    when(mockRestaurantsFilterSearchResultsBloc.state).thenReturn(
      restaurantsFilterSuccessState,
    );
    SizeConfig.blockSizeVertical = 8;
    SizeConfig.screenWidth = 1000;
    SizeConfig.screenHeight = 2000;
    HttpOverrides.global = null;
  });

  Widget liveSearchPage() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserLocationBloc>(
            create: (context) => mockUserLocationBloc),
        BlocProvider<SearchBloc>(create: (context) => mockSearchBloc),
        BlocProvider<CategoriesToggleBloc>(
            create: (context) => mockCategoriesToggleBloc),
        BlocProvider<LocalSearchHistoryBloc>(
          create: (context) => mockLocalSearchHistoryBloc,
        ),
        BlocProvider<RestaurantsFilterSearchResultsBloc>(
          create: (context) => mockRestaurantsFilterSearchResultsBloc,
        ),
        BlocProvider<SearchQueryCubit>(
          create: (_) => SearchQueryCubit(),
        ),
        BlocProvider<LiveSearchCubit>(
          create: (_) => LiveSearchCubit(),
        ),
        BlocProvider<PopularSearchesBloc>(
          create: (_) => mockPopularSearchesBloc,
        )
      ],
      child: MaterialApp(
        locale: const Locale('en', 'US'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return const LiveSearchPage();
          },
        ),
      ),
    );
  }

  group('LiveSearchPage Tests', () {
    testWidgets('should display initial loading indicator',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(SearchLoading());

      await tester.pumpWidget(liveSearchPage());
      await tester.pump();
      expect(
        find.byKey(
          const Key('live search loading'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display restaurants search results when data is loaded',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        RestaurantSearchLoaded(
          results: [
            RestaurantResult(id: "1", name: "Boss Burger"),
            RestaurantResult(id: "2", name: "Celavie Restaurant"),
            RestaurantResult(id: "3", name: "Berhan Shiro"),
          ],
        ),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultTile), findsWidgets);
    });

    testWidgets(
        'should display restaurants search results when data is loaded and empty',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        RestaurantSearchLoaded(
          results: [],
        ),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      expect(
          find.text("Sorry, we couldn't find any results matching your search"),
          findsWidgets);
    });

    testWidgets('should display restaurants search failed',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        SearchError(
          error: "failed to get results",
        ),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      expect(
          find.text("Unable to load results. Please try again."), findsWidgets);
    });

    testWidgets(
        'should display LocalSearches and PopularSearches when state is initial and location is loaded',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        SearchInitial(),
      );
      when(mockLocalSearchHistoryBloc.state).thenReturn(
        LocalSearchHistoryLoaded(
          histories: [
            History(
              id: "1",
              title: "history title",
            )
          ],
        ),
      );
      when(mockPopularSearchesBloc.state).thenReturn(
        PopularSearchesLoaded(
          popularSearchItems: PopularSearchItems(
            items: [
              "item 1",
              "item 2",
            ],
            restaurants: [
              "restaurant 1",
              "restaurant 2",
            ],
          ),
        ),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      expect(find.byType(LocalSearches), findsWidgets);
      expect(find.byKey(Key('history_0')), findsOneWidget);
      expect(find.text("Recent searches"), findsOneWidget);

      expect(find.byType(PopularSearches), findsWidgets);
      expect(find.text('restaurant 1'), findsOneWidget);
      expect(find.text('restaurant 2'), findsOneWidget);
    });

    testWidgets('should display items search results when data is loaded',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        ItemSearchLoaded(
          results: dummyItems,
        ),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultTile), findsWidgets);
    });

    testWidgets('should handle user location error properly',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(
        const UserLocationError(message: 'Location permission needed'),
      );

      await tester.pumpWidget(liveSearchPage());
      await tester.pumpAndSettle();

      // expect(find.text('Location permission needed'), findsOneWidget);
      expect(
        find.byKey(const Key("Can't get user location")),
        findsOneWidget,
      );
    });
  });
}
