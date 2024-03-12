// filepath: /home/abrham/Documents/dev/a2sv/RateEat/rateeat_mobile/test/features/search/presentation/widget_test/categories_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'categories_test.mocks.dart';

abstract class UserLocationState {}

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}

class UserLocationLoaded extends UserLocationState {
  final UserLocation location;

  UserLocationLoaded({required this.location});
}

@GenerateNiceMocks([
  MockSpec<CategoriesToggleBloc>(),
  MockSpec<FastingToggleBloc>(),
  MockSpec<UserLocationBloc>(),
  MockSpec<ItemsFilterSearchResultsBloc>(),
  MockSpec<RestaurantsFilterSearchResultsBloc>(),
  MockSpec<LiveSearchCubit>(),
  MockSpec<SearchPageCubit>(),
])

// Custom mock for TabController since it needs special behavior
class MockTabController extends Mock implements TabController {
  int _index = 0;

  @override
  int get index => _index;

  @override
  set index(int value) {
    _index = value;
    notifyListeners();
  }

  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

// Mock for AppLocalizations

void main() {
  late MockTabController tabController;
  late MockCategoriesToggleBloc categoriesToggleBloc;
  late MockFastingToggleBloc fastingToggleBloc;
  late MockUserLocationBloc userLocationBloc;
  late MockItemsFilterSearchResultsBloc itemsFilterSearchResultsBloc;
  late MockRestaurantsFilterSearchResultsBloc
      restaurantsFilterSearchResultsBloc;
  late MockLiveSearchCubit liveSearchCubit;
  late MockSearchPageCubit searchPageCubit;

  setUp(() {
    tabController = MockTabController();
    categoriesToggleBloc = MockCategoriesToggleBloc();
    fastingToggleBloc = MockFastingToggleBloc();
    userLocationBloc = MockUserLocationBloc();
    itemsFilterSearchResultsBloc = MockItemsFilterSearchResultsBloc();
    restaurantsFilterSearchResultsBloc =
        MockRestaurantsFilterSearchResultsBloc();
    liveSearchCubit = MockLiveSearchCubit();
    searchPageCubit = MockSearchPageCubit();

    // Setup default behavior for mocks
    when(categoriesToggleBloc.state).thenReturn(0);
    when(fastingToggleBloc.state).thenReturn(false);
  });

  testWidgets('ItemCategories renders correctly', (WidgetTester tester) async {
    // Initialize SizeConfig
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            SizeConfig().init(context);
            return const SizedBox.shrink(); // Placeholder
          },
        ),
      ),
    );

    // Build our widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<CategoriesToggleBloc>.value(
                    value: categoriesToggleBloc),
                BlocProvider<FastingToggleBloc>.value(value: fastingToggleBloc),
                BlocProvider<UserLocationBloc>.value(value: userLocationBloc),
                BlocProvider<ItemsFilterSearchResultsBloc>.value(
                    value: itemsFilterSearchResultsBloc),
                BlocProvider<RestaurantsFilterSearchResultsBloc>.value(
                    value: restaurantsFilterSearchResultsBloc),
                BlocProvider<LiveSearchCubit>.value(value: liveSearchCubit),
                BlocProvider<SearchPageCubit>.value(value: searchPageCubit),
              ],
              child: Scaffold(
                body: ItemCategories(tabController: tabController),
              ),
            );
          },
        ),
      ),
    );

    // Verify that the widget renders without errors
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify tab switching works
    expect(tabController.index, 0);
    await tester.tap(find.text('Items'));
    await tester.pumpAndSettle();
    verify(categoriesToggleBloc.toggleSwitch(1)).called(1);
  });
}
