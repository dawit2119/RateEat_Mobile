import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/domain/entities/location.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/currentLocation/current_location.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_state.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_state.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/pages/change_user_location.dart';
import 'package:rateeat_mobile/src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import './change_user_location_test.mocks.dart';

// Mock classes
class MockUserLocationBloc extends Mock implements UserLocationBloc {}

class MockSearchQueryCubit extends Mock implements SearchQueryCubit {}

class MockPopularBloc extends Mock implements PopularBloc {}

class MockTagBloc extends Mock implements TagBloc {}

class MockLocationDescriptionBloc extends Mock
    implements LocationDescriptionBloc {}

class MockHomePageNearbyRestaurantBloc extends Mock
    implements HomePageNearbyRestaurantBloc {}

@GenerateNiceMocks([
  MockSpec<MockUserLocationBloc>(),
  MockSpec<MockSearchQueryCubit>(),
  MockSpec<MockPopularBloc>(),
  MockSpec<MockTagBloc>(),
  MockSpec<MockLocationDescriptionBloc>(),
  MockSpec<MockHomePageNearbyRestaurantBloc>(),
])
void main() {
  late MockUserLocationBloc mockUserLocationBloc;
  late MockSearchQueryCubit mockSearchQueryCubit;
  late MockPopularBloc mockPopularBloc;
  late MockTagBloc mockTagBloc;
  late MockLocationDescriptionBloc mockLocationDescriptionBloc;
  late MockHomePageNearbyRestaurantBloc mockHomePageNearbyRestaurantBloc;

  setUp(() {
    mockUserLocationBloc = MockMockUserLocationBloc();
    mockSearchQueryCubit = MockMockSearchQueryCubit();
    mockPopularBloc = MockMockPopularBloc();
    mockTagBloc = MockMockTagBloc();
    mockLocationDescriptionBloc = MockMockLocationDescriptionBloc();
    mockHomePageNearbyRestaurantBloc = MockMockHomePageNearbyRestaurantBloc();

    when(mockUserLocationBloc.state).thenReturn(const UserLocationLoaded(
        location: Location(latitude: 37.7749, longitude: -122.4194)));
    when(mockSearchQueryCubit.state).thenReturn('Search for a place');
    when(mockPopularBloc.state).thenReturn(
      const TopRatedState(
        popular: [],
      ),
    );
    when(mockTagBloc.state).thenReturn(
      const SelectedTagState([]),
    );
    SizeConfig.blockSizeVertical = 8;
    SizeConfig.screenWidth = 1000;
    SizeConfig.screenHeight = 2000;
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserLocationBloc>(create: (_) => mockUserLocationBloc),
        BlocProvider<SearchQueryCubit>(create: (_) => mockSearchQueryCubit),
        BlocProvider<PopularBloc>(create: (_) => mockPopularBloc),
        BlocProvider<TagBloc>(create: (_) => mockTagBloc),
        BlocProvider<LocationDescriptionBloc>(
            create: (_) => mockLocationDescriptionBloc),
        BlocProvider<HomePageNearbyRestaurantBloc>(
            create: (_) => mockHomePageNearbyRestaurantBloc),
      ],
      child: MaterialApp(
        locale: const Locale('en', 'US'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return body;
          },
        ),
      ),
    );
  }

  group("Change user location widget testing", () {
    testWidgets(
        'Should initialize and display map when user location is loaded',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(const UserLocationLoaded(
          location: Location(latitude: 37.7749, longitude: -122.4194)));
      await tester
          .pumpWidget(makeTestableWidget(const ChangeUserLocationScreen()));
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets(
        'Should display loading animation when user location is loading',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(const UserLocationLoading());
      await tester
          .pumpWidget(makeTestableWidget(const ChangeUserLocationScreen()));
      expect(find.byKey(const Key('loading_map')), findsOneWidget);
    });

    testWidgets(
        'Should display error message when there is an error loading user location',
        (WidgetTester tester) async {
      when(mockUserLocationBloc.state).thenReturn(
          const UserLocationError(message: "Error loading location"));
      await tester.pumpWidget(
        makeTestableWidget(
          const ChangeUserLocationScreen(),
        ),
      );
      expect(find.byType(FailureStateWidget), findsOneWidget);
    });
  });
}
