import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/domain/entities/location.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/currentLocation/current_location.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discovery_steps.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import './map_page_test.mocks.dart';

// Mock classes
class MockUserLocationBloc extends Mock implements UserLocationBloc {}

class MockNetworkBloc extends Mock implements NetworkBloc {}

class MockAllRestaurantsBloc extends Mock implements AllRestaurantsBloc {}

class MockMapZoomBloc extends Mock implements MapZoomBloc {}

class MockTransportModeCubit extends Mock implements TransportModeCubit {}

class MockMapMarkersBloc extends Mock implements MapMarkersBloc {}

class MockShowWalkingDistanceTileBloc extends Mock
    implements ShowWalkingDistanceTileBloc {}

@GenerateNiceMocks([
  MockSpec<MockUserLocationBloc>(),
  MockSpec<MockNetworkBloc>(),
  MockSpec<MockAllRestaurantsBloc>(),
  MockSpec<MockMapZoomBloc>(),
  MockSpec<MockTransportModeCubit>(),
  MockSpec<MockShowWalkingDistanceTileBloc>(),
  MockSpec<MockMapMarkersBloc>(),
])
void main() {
  late MockUserLocationBloc mockUserLocationBloc;
  late MockNetworkBloc mockNetworkBloc;
  late MockAllRestaurantsBloc mockAllRestaurantsBloc;
  late MockMapZoomBloc mockMapZoomBloc;
  late MockTransportModeCubit mockTransportModeCubit;
  late MockShowWalkingDistanceTileBloc mockShowWalkingDistanceTileBloc;
  late MockMapMarkersBloc mockMapMarkersBloc;

  setUp(() {
    mockUserLocationBloc = MockMockUserLocationBloc();
    mockNetworkBloc = MockMockNetworkBloc();
    mockAllRestaurantsBloc = MockMockAllRestaurantsBloc();
    mockMapZoomBloc = MockMockMapZoomBloc();
    mockTransportModeCubit = MockMockTransportModeCubit();
    mockShowWalkingDistanceTileBloc = MockMockShowWalkingDistanceTileBloc();
    mockMapMarkersBloc = MockMockMapMarkersBloc();
    when(mockUserLocationBloc.state).thenReturn(const UserLocationLoaded(
        location: Location(latitude: 37.7749, longitude: -122.4194)));
    when(mockAllRestaurantsBloc.state).thenReturn(AllRestaurantsLoading());
    when(mockMapZoomBloc.state)
        .thenReturn(MapZoomState(zoomLevel: 12, isWalking: true));
    when(mockTransportModeCubit.state).thenReturn(TransportMode.walking);
    when(mockShowWalkingDistanceTileBloc.state).thenReturn(false);
    SizeConfig.blockSizeVertical = 8;
    SizeConfig.screenWidth = 1000;
    SizeConfig.screenHeight = 2000;
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserLocationBloc>(create: (_) => mockUserLocationBloc),
        BlocProvider<NetworkBloc>(create: (_) => mockNetworkBloc),
        BlocProvider<AllRestaurantsBloc>(create: (_) => mockAllRestaurantsBloc),
        BlocProvider<MapZoomBloc>(create: (_) => mockMapZoomBloc),
        BlocProvider<TransportModeCubit>(create: (_) => mockTransportModeCubit),
        BlocProvider<ShowWalkingDistanceTileBloc>(
            create: (_) => mockShowWalkingDistanceTileBloc),
        BlocProvider<MapMarkersBloc>(
          create: (_) => mockMapMarkersBloc,
        ),
        BlocProvider<DiscoveryStepsBloc>(
          create: (_) => DiscoveryStepsBloc(),
        ),
        BlocProvider<SearchQueryCubit>(
          create: (_) => SearchQueryCubit(),
        ),
        BlocProvider<DisplayRestaurantCountAndWalkingDistance>(
          create: (_) => DisplayRestaurantCountAndWalkingDistance(),
        ),
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

  group("Map Page widget testing", () {
    testWidgets('Should display loading animation when data is loading',
        (WidgetTester tester) async {
      when(mockAllRestaurantsBloc.state).thenReturn(
        AllRestaurantsLoading(),
      );
      when(mockNetworkBloc.state).thenReturn(NetworkInitial());

      await tester.pumpWidget(makeTestableWidget(const LocationOnMap()));
      expect(
          find.byKey(
            const Key('loading_map'),
          ),
          findsOneWidget);
    });

    testWidgets('Should display map content when data is loaded',
        (WidgetTester tester) async {
      when(mockNetworkBloc.state).thenReturn(NetworkSuccess());

      when(mockAllRestaurantsBloc.state).thenReturn(
        AllRestaurantsSuccess(
          restaurants: const [],
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const LocationOnMap()));
      expect(find.byType(GoogleMapContent), findsOneWidget);
    });

    testWidgets('Should display error message when network fails',
        (WidgetTester tester) async {
      when(mockNetworkBloc.state).thenReturn(NetworkFailed());
      await tester.pumpWidget(
        makeTestableWidget(
          const LocationOnMap(),
        ),
      );
      expect(
        find.byType(FailureStateWidget),
        findsOneWidget,
      );
    });
  });
}
