import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_state.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_state.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/item_tile.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'homepage_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PopularBloc>(),
  MockSpec<RecommendedBloc>(),
  MockSpec<HomePageNearbyRestaurantBloc>(),
  MockSpec<TagBloc>(),
  MockSpec<UserLocationBloc>(),
  MockSpec<NetworkBloc>(),
  MockSpec<SearchFoodCategoryBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<LocationDescriptionBloc>(),
  MockSpec<UnreadNotificationsCounterBloc>(),
  MockSpec<HomeFastingToggleBloc>(),
  MockSpec<SearchQueryCubit>(),
  MockSpec<OrdersCountBloc>(),
])
void main() {
  group('HomePage Widget Tests', () {
    late MockPopularBloc popularBloc;
    late MockRecommendedBloc recommendedBloc;
    late MockHomePageNearbyRestaurantBloc nearbyRestaurantBloc;
    late MockTagBloc tagBloc;
    late MockUserLocationBloc userLocationBloc;
    late MockNetworkBloc mockNetworkBloc;
    late MockSearchFoodCategoryBloc mockSearchFoodCategoryBloc;
    late MockAuthenticationLocalSource mockAuthLocalSource;
    late MockLocationDescriptionBloc mockLocationDescriptionBloc;
    late MockUnreadNotificationsCounterBloc mockUnreadNotificationsCounterBloc;
    late MockHomeFastingToggleBloc mockHomeFastingToggleBloc;
    late MockSearchQueryCubit mockSearchQueryCubit;
    late MockOrdersCountBloc mockOrdersCountBloc;

    setUpAll(() {
      if (dpLocator.isRegistered<AuthenticationLocalSource>()) {
        dpLocator.unregister<AuthenticationLocalSource>();
      }
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => mockAuthLocalSource);
    });

    setUp(() {
      popularBloc = MockPopularBloc();
      recommendedBloc = MockRecommendedBloc();
      nearbyRestaurantBloc = MockHomePageNearbyRestaurantBloc();
      tagBloc = MockTagBloc();
      userLocationBloc = MockUserLocationBloc();
      mockNetworkBloc = MockNetworkBloc();
      mockSearchFoodCategoryBloc = MockSearchFoodCategoryBloc();
      mockAuthLocalSource = MockAuthenticationLocalSource();
      mockLocationDescriptionBloc = MockLocationDescriptionBloc();
      mockUnreadNotificationsCounterBloc = MockUnreadNotificationsCounterBloc();
      mockHomeFastingToggleBloc = MockHomeFastingToggleBloc();
      mockSearchQueryCubit = MockSearchQueryCubit();
      mockOrdersCountBloc = MockOrdersCountBloc();

      when(popularBloc.state)
          .thenReturn(TopRatedState(status: ItemStatus.loaded));
      when(recommendedBloc.state)
          .thenReturn(RecommendedRestaurantFetched(restaurants: []));
      when(nearbyRestaurantBloc.state)
          .thenReturn(NearbyRestaurantFetched(restaurants: [
        RestaurantModel(),
        RestaurantModel(),
        RestaurantModel(),
      ]));
      when(tagBloc.state).thenReturn(SelectedTagState([]));
      when(userLocationBloc.state).thenReturn(
          UserLocationLoaded(location: Location(latitude: 0, longitude: 0)));
      when(mockNetworkBloc.state).thenReturn(NetworkSuccess());
      when(mockSearchFoodCategoryBloc.state).thenReturn(SearchSuccess([]));
      when(mockLocationDescriptionBloc.state).thenReturn(
          LocationDescriptionState(locationDescription: "test_location"));

      when(mockUnreadNotificationsCounterBloc.state)
          .thenReturn(UnreadNotificationsCounterFetched(count: 0));
      when(mockHomeFastingToggleBloc.state).thenReturn(false);
      when(mockSearchQueryCubit.state).thenReturn("query");
      when(mockOrdersCountBloc.state).thenReturn(OrdersCountLoaded(count: 0));

      final token = "test_token";
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);
    });

    Widget createWidgetUnderTest() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<PopularBloc>(
            create: (_) => popularBloc,
          ),
          BlocProvider<RecommendedBloc>(
            create: (_) => recommendedBloc,
          ),
          BlocProvider<HomePageNearbyRestaurantBloc>(
            create: (_) => nearbyRestaurantBloc,
          ),
          BlocProvider<TagBloc>(
            create: (_) => tagBloc,
          ),
          BlocProvider<UserLocationBloc>(
            create: (_) => userLocationBloc,
          ),
          BlocProvider<SearchFoodCategoryBloc>(
            create: (_) => mockSearchFoodCategoryBloc,
          ),
          BlocProvider<NetworkBloc>(
            create: (_) => mockNetworkBloc,
          ),
          BlocProvider<LocationDescriptionBloc>(
            create: (_) => mockLocationDescriptionBloc,
          ),
          BlocProvider<UnreadNotificationsCounterBloc>(
            create: (_) => mockUnreadNotificationsCounterBloc,
          ),
          BlocProvider<HomeFastingToggleBloc>(
            create: (_) => mockHomeFastingToggleBloc,
          ),
          BlocProvider<SearchQueryCubit>(
            create: (_) => mockSearchQueryCubit,
          ),
          BlocProvider<OrdersCountBloc>(
            create: (_) => mockOrdersCountBloc,
          ),
        ],
        child: ResponsiveSizer(builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomePage(),
          );
        }),
      );
    }

    testWidgets('HomePage renders correctly', (tester) async {
      when(mockSearchFoodCategoryBloc.state).thenReturn(SearchSuccess([
        ItemCategoryModel(
          id: '1',
          name: 'category1',
        ),
        ItemCategoryModel(
          id: '2',
          name: 'category2',
        ),
        ItemCategoryModel(
          id: '3',
          name: 'category3',
        ),
        ItemCategoryModel(
          id: '4',
          name: 'category4',
        ),
      ]));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(HomePageAppBar), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ItemTile), findsNWidgets(4));
      expect(find.text('category1'), findsOneWidget);
      expect(find.text('category2'), findsOneWidget);
      expect(find.text('category3'), findsOneWidget);
      expect(find.text('category4'), findsOneWidget);
    });

    testWidgets('renders loading indicator when popular items are loading',
        (WidgetTester tester) async {
      when(popularBloc.state)
          .thenReturn(TopRatedState(status: ItemStatus.loading));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PopularItemsShimmerHorizontal), findsOneWidget);
    });

    testWidgets('displays error message when there is no popular item',
        (WidgetTester tester) async {
      when(popularBloc.state)
          .thenReturn(TopRatedState(status: ItemStatus.loaded, popular: []));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('No top rated found'), findsOneWidget);
    });

    testWidgets('renders popular items card when popular items are loaded',
        (WidgetTester tester) async {
      when(popularBloc.state).thenReturn(TopRatedState(
        status: ItemStatus.loaded,
        popular: [
          ItemModel(itemId: "1", itemName: "shewarma", numberOfReviews: 5),
          ItemModel(itemId: "2", itemName: "shewarma 2", numberOfReviews: 6),
          ItemModel(itemId: "3", itemName: "shewarma 3", numberOfReviews: 7),
        ],
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(FoodCard), findsNWidgets(3));
    });

    // testWidgets('triggers refresh on pull down', (WidgetTester tester) async {
    //   when(popularBloc.state).thenReturn(TopRatedState(
    //     status: ItemStatus.loaded,
    //     popular: [
    //       ItemModel(itemId: "1", itemName: "shewarma", numberOfReviews: 5),
    //       ItemModel(itemId: "2", itemName: "shewarma 2", numberOfReviews: 6),
    //       ItemModel(itemId: "3", itemName: "shewarma 3", numberOfReviews: 7),
    //     ],
    //   ));

    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pump();

    //   await tester.fling(
    //       find.byType(RefreshIndicator), const Offset(0, 300), 1000);

    //   verify(popularBloc.add(any)).called(1);
    //   verify(recommendedBloc.add(any)).called(1);
    //   verify(nearbyRestaurantBloc.add(any)).called(1);
    // });
    testWidgets('Displays error message on network failure', (tester) async {
      when(mockNetworkBloc.state).thenReturn(NetworkFailed());
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('should call fasting toggle on block when button pressed',
        (tester) async {
      when(mockHomeFastingToggleBloc.state).thenReturn(false);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byKey(const Key('fasting_toggle_button')));
      verify(mockHomeFastingToggleBloc.toggleSwitch()).called(1);
    });

    testWidgets('should retry calling popular bloc on itemstatus.error',
        (tester) async {
      when(popularBloc.state)
          .thenReturn(TopRatedState(status: ItemStatus.error));
      await tester.pumpWidget(createWidgetUnderTest());
      verify(popularBloc.add(any)).called(greaterThan(0));
    });

    testWidgets(
        'should display retry button when near by fails and retry should call bloc',
        (tester) async {
      when(nearbyRestaurantBloc.state)
          .thenReturn(NearbyRestaurantFailure(err: "Network error"));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Retry'), findsAtLeastNWidgets(1));
      await tester.tap(find.text('Retry').last, warnIfMissed: false);
      verify(nearbyRestaurantBloc.add(any)).called(1);
    });

    // testWidgets('on tag filter should call popular bloc and near by bloc',
    //     (tester) async {
    //   when(mockSearchFoodCategoryBloc.state).thenReturn(SearchSuccess([
    //     ItemCategoryModel(id: "1", name: "category 1"),
    //     ItemCategoryModel(id: "2", name: "category 2"),
    //     ItemCategoryModel(id: "3", name: "category 3"),
    //   ]));
    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.tap(find.byType(ItemTile).last);
    //   await tester.pump(Duration(seconds: 10));
    //   verify(tagBloc.add(any)).called(1);
    //   verify(popularBloc.add(any)).called(1);
    //   verify(nearbyRestaurantBloc.add(any)).called(1);
    // });

    testWidgets('should show retry when category fetch fails', (tester) async {
      when(mockSearchFoodCategoryBloc.state)
          .thenReturn(SearchError(message: "network error"));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Retry'), findsAtLeastNWidgets(1));
    });
    testWidgets('should show recommended restaurats when location fails',
        (tester) async {
      when(userLocationBloc.state)
          .thenReturn(UserLocationError(message: "location error"));
      when(recommendedBloc.state)
          .thenReturn(RecommendedRestaurantFetched(restaurants: [
        RecommendedRestaurantModel(
          numberOfReviews: 0,
        )
      ]));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.byType(RecommendedRestaurantWidget), findsOneWidget);
    });
    testWidgets(
        'should show no recommendation found error when there is no recommendation',
        (tester) async {
      when(userLocationBloc.state)
          .thenReturn(UserLocationError(message: "location error"));
      when(recommendedBloc.state)
          .thenReturn(RecommendedRestaurantFetched(restaurants: []));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ErrorAndInfoDisplayWidget), findsAtLeastNWidgets(1));
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.byType(RecommendedRestaurantWidget), findsNothing);
    });
    testWidgets('should show error page when recommendation fetching fails',
        (tester) async {
      when(userLocationBloc.state)
          .thenReturn(UserLocationError(message: "location error"));
      when(recommendedBloc.state).thenReturn(
          RecommendedRestaurantFailure(errorMessage: "network error"));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ErrorAndInfoDisplayWidget), findsAtLeastNWidgets(1));
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.byType(RecommendedRestaurantWidget), findsNothing);
    });
  });
}
