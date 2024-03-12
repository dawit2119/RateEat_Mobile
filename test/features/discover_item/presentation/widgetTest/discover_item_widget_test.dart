import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/filter_modal_sheet.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/item_result_page.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/search_page.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'discover_item_widget_test.mocks.dart';

class MockLocalAnalyticsObserver extends Mock
    implements LocalAnalyticsObserver {}

class MockAnalyticsObserver extends Mock implements AnalyticsObserver {}

class MockAuthenticationLocalSource extends Mock
    implements AuthenticationLocalSource {}

class MockSearchRestaurantsBloc extends Mock implements SearchRestaurantsBloc {}

class MockDiscoverMenuPriceSelectorCubit extends Mock
    implements DiscoverMenuPriceSelectorCubit {}

class MockDiscoverMenuItemSelectorCubit extends Mock
    implements DiscoverMenuRatingSelectorCubit {}

class MockDiscoverItemPageCubit extends Mock
    implements DiscoveryItemPageCubit {}

class MockFilterItemsBloc extends Mock implements FilterItemsBloc {}

class MockHomePageNearByBloc extends Mock
    implements HomePageNearbyRestaurantBloc {}

class MockUserLocationBloc extends Mock implements UserLocationBloc {}

class MockSelectedRestaurantBloc extends Mock
    implements SelectedRestaurantBloc {}

@GenerateNiceMocks([
  MockSpec<MockSearchRestaurantsBloc>(),
  MockSpec<MockDiscoverMenuPriceSelectorCubit>(),
  MockSpec<MockDiscoverMenuItemSelectorCubit>(),
  MockSpec<MockDiscoverItemPageCubit>(),
  MockSpec<MockFilterItemsBloc>(),
  MockSpec<MockHomePageNearByBloc>(),
  MockSpec<MockAuthenticationLocalSource>(),
  MockSpec<MockLocalAnalyticsObserver>(),
  MockSpec<MockAnalyticsObserver>(),
  MockSpec<MockUserLocationBloc>(),
  MockSpec<MockSelectedRestaurantBloc>()
])
void main() {
  group('Leadear board Widget Test', () {
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockSearchRestaurantsBloc mockSearchRestaurantsBloc;
    late MockDiscoverMenuPriceSelectorCubit mockDiscoverMenuPriceSelectorCubit;
    late MockDiscoverItemPageCubit mockDiscoverItemPageCubit;
    late MockDiscoverMenuItemSelectorCubit mockMenuItemSelectorCubit;
    late MockFilterItemsBloc mockFilterItemsBloc;
    late MockHomePageNearByBloc mockHomePageNearByBloc;

    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late MockUserLocationBloc mockUserLocationBloc;

    late MockSelectedRestaurantBloc mockSelectedRestaurantBloc;

    setUp(() {
      mockLocalAnalyticsObserver = MockLocalAnalyticsObserver();
      mockAnalyticsObserver = MockAnalyticsObserver();
      mockSearchRestaurantsBloc = MockMockSearchRestaurantsBloc();
      mockDiscoverMenuPriceSelectorCubit =
          MockMockDiscoverMenuPriceSelectorCubit();
      mockDiscoverMenuPriceSelectorCubit =
          MockMockDiscoverMenuPriceSelectorCubit();
      mockMenuItemSelectorCubit = MockMockDiscoverMenuItemSelectorCubit();
      mockDiscoverItemPageCubit = MockMockDiscoverItemPageCubit();
      mockFilterItemsBloc = MockMockFilterItemsBloc();
      mockHomePageNearByBloc = MockMockHomePageNearByBloc();
      mockAuthenticationLocalSource = MockMockAuthenticationLocalSource();
      mockUserLocationBloc = MockMockUserLocationBloc();
      mockSelectedRestaurantBloc = MockMockSelectedRestaurantBloc();
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => MockMockAuthenticationLocalSource());
      dpLocator.registerFactory<LocalAnalyticsObserver>(
        () => mockLocalAnalyticsObserver,
      );
      dpLocator.registerFactory<AnalyticsObserver>(
        () => mockAnalyticsObserver,
      );
      dpLocator.registerFactory<SearchRestaurantsBloc>(
          () => mockSearchRestaurantsBloc);
      dpLocator.registerFactory<FilterItemsBloc>(() => mockFilterItemsBloc);

      dpLocator.registerFactory<HomePageNearbyRestaurantBloc>(
          () => mockHomePageNearByBloc);
      dpLocator.registerFactory<DiscoverMenuPriceSelectorCubit>(
          () => mockDiscoverMenuPriceSelectorCubit);
      dpLocator.registerFactory<DiscoverMenuRatingSelectorCubit>(
          () => mockMenuItemSelectorCubit);
      dpLocator.registerFactory<DiscoveryItemPageCubit>(
          () => mockDiscoverItemPageCubit);
      dpLocator.registerFactory<UserLocationBloc>(() => mockUserLocationBloc);
      dpLocator.registerFactory<SelectedRestaurantBloc>(
          () => mockSelectedRestaurantBloc);

      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => dpLocator<UserLocationBloc>()),
          BlocProvider(create: (context) => dpLocator<SearchRestaurantsBloc>()),
          BlocProvider(create: (context) => dpLocator<FilterItemsBloc>()),
          BlocProvider(
            create: (context) => dpLocator<HomePageNearbyRestaurantBloc>(),
          ),
          BlocProvider(
              create: (context) => dpLocator<DiscoverMenuPriceSelectorCubit>()),
          BlocProvider(
              create: (context) => dpLocator<DiscoverMenuPriceSelectorCubit>()),
          BlocProvider(
              create: (context) => dpLocator<DiscoveryItemPageCubit>()),
          BlocProvider(
              create: (context) => dpLocator<SelectedRestaurantBloc>()),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ResponsiveSizer(builder: (context, orientation, screenType) {
            return body;
          }),
        ),
      );
    }

    testWidgets('Should display search field ', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));

      expect(find.byType(CustomTextInputField), findsOneWidget);
    });

    testWidgets(
        'Should display loading state when search restaurant is in loading state',
        (WidgetTester tester) async {
      when(mockSearchRestaurantsBloc.stream)
          .thenAnswer((_) => Stream.value(SearchRestaurantLoading()));
      when(mockSearchRestaurantsBloc.state)
          .thenReturn(SearchRestaurantLoading());

      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));

      await tester.pumpAndSettle();

      // Use runAsync to handle asynchronous operations
      await tester.runAsync(() async {
        // Find the CustomTextInputField widget
        final textFieldFinder = find.byKey(const Key('searchRestaurantField'));
        expect(textFieldFinder, findsOneWidget);

        // Enter text into the CustomTextInputField
        await tester.enterText(textFieldFinder, 'pizza');

        // Pump for additional time to simulate asynchronous operations
        for (int i = 0; i < 5; i++) {
          await tester.pump(Duration(seconds: 1));
        }

        // Verify the loading state
        expect(
            find.byKey(const Key("searchrestaurantloading")), findsOneWidget);
      });
    });

    testWidgets(
        'Should display success but empty state search restaurant is in  sucess state',
        (WidgetTester tester) async {
      when(mockSearchRestaurantsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockSearchRestaurantsBloc.state)
          .thenAnswer((_) => const SearchRestaurantSuccess([]));

      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));

      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(CustomTextInputField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'pizza');

      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display success state search restaurant is in sucess state',
        (WidgetTester tester) async {
      when(mockSearchRestaurantsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockSearchRestaurantsBloc.state).thenAnswer((_) =>
          SearchRestaurantSuccess(
              [RestaurantResult(id: 'id', name: 'restaurant')]));
      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));
      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(CustomTextInputField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'pizza');

      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
        'Should display error state search restaurant is in err0r state',
        (WidgetTester tester) async {
      when(mockSearchRestaurantsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockSearchRestaurantsBloc.state)
          .thenAnswer((_) => const SearchRestaurantsError(message: "message"));

      await tester.pumpWidget(Builder(
        builder: (context) {
          SizeConfig().init(context);
          return makeTestableWidget(const SearchRestaurantPage());
        },
      ));
      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(CustomTextInputField);

      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'pizza');

      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display initial state search restaurant is in initial state',
        (WidgetTester tester) async {
      when(mockSearchRestaurantsBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockSearchRestaurantsBloc.state)
          .thenAnswer((_) => const SearchRestaurantsError(message: "message"));
      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));

      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));
      await tester.pumpAndSettle();

      final textInputField = find.byType(CustomTextInputField);
      expect(textInputField, findsOneWidget);

      await tester.enterText(textInputField, 'pizza');
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should displaySuccess when nearby restaurant is in sucess state',
        (WidgetTester tester) async {
      when(mockHomePageNearByBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockHomePageNearByBloc.state)
          .thenAnswer((_) => NearbyRestaurantFetched(restaurants: const []));

      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));

      await tester.pumpWidget(makeTestableWidget(const SearchRestaurantPage()));
      await tester.pumpAndSettle();

      final textInputField = find.byType(CustomTextInputField);
      expect(textInputField, findsOneWidget);

      await tester.enterText(textInputField, 'pizza');

      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display error when nearby restaurant is in erreor state',
        (WidgetTester tester) async {
      when(mockHomePageNearByBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockHomePageNearByBloc.state)
          .thenAnswer((_) => NearbyRestaurantFailure(err: "err"));
      await tester.pumpWidget(Builder(builder: (context) {
        SizeConfig().init(context);
        return makeTestableWidget(const SearchRestaurantPage());
      }));

      await tester.pumpAndSettle();

      final textInputField = find.byType(CustomTextInputField);
      expect(textInputField, findsOneWidget);
      await tester.enterText(textInputField, 'pizza');
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });
  });
}
