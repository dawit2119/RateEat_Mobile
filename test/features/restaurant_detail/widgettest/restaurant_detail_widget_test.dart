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
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';

import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_review_response.dart';

import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';

import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_state.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/popular_restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/screens/restaurant_detail.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/popular_items.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_menu_item.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/restaurant_review_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/custom_tab_bar.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

import 'restaurant_detail_widget_test.mocks.dart';

class MockRestaurantDetailBloc extends Mock implements RestaurantDetailBloc {}

class MockLocalAnalyticsObserver extends Mock
    implements LocalAnalyticsObserver {}

class MockAnalyticsObserver extends Mock implements AnalyticsObserver {}

class MockAuthenticationLocalSource extends Mock
    implements AuthenticationLocalSource {}

class MockUserReviews extends Mock implements UserReviewsPageCubit {}

class MockRestaurantPopularReviews extends Mock
    implements RestaurantPopularReviewsBloc {}

class MockRestaurantPopularItemsBloc extends Mock
    implements RestaurantPopularItemsBloc {}

class MockMapMarkersBloc extends Mock implements MapMarkersBloc {}

@GenerateNiceMocks([
  MockSpec<MockRestaurantDetailBloc>(),
  MockSpec<MockAuthenticationLocalSource>(),
  MockSpec<MockLocalAnalyticsObserver>(),
  MockSpec<MockAnalyticsObserver>(),
  MockSpec<MockUserReviews>(),
  MockSpec<MockRestaurantPopularReviews>(),
  MockSpec<MockRestaurantPopularItemsBloc>(),
  MockSpec<MockMapMarkersBloc>(),
  MockSpec<CartCubit>(),
  MockSpec<UserLocationBloc>(),
  MockSpec<FavoriteBloc>(),
  MockSpec<VideoPlayerController>(),
  MockSpec<DeleteRestaurantReviewBloc>(),
  MockSpec<VoteOnReviewBloc>(),
  MockSpec<UpVoteItemReviewUseCase>(),
  MockSpec<UpVoteRestaurantReviewUseCase>(),
  MockSpec<DownVoteItemReviewUseCase>(),
  MockSpec<DownVoteRestaurantReviewUseCase>(),
])
void main() {
  group('RestaurantDetail Widget Test', () {
    late MockRestaurantDetailBloc mockRestaurantDetailBloc;
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockUserReviews mockUserReviews;
    late MockRestaurantPopularReviews mockRestaurantPopularReviews;
    late MockRestaurantPopularItemsBloc mockRestaurantPopularItemsBloc;
    late MockMapMarkersBloc mockMapMarkersBloc;
    late MockCartCubit mockCartCubit;
    late MockUserLocationBloc mockUserLocationBloc;
    late MockFavoriteBloc mockFavoriteBloc;
    late MockVideoPlayerController mockVideoPlayerController;
    late MockDeleteRestaurantReviewBloc mockDeleteRestaurantReviewBloc;
    late MockVoteOnReviewBloc mockVoteOnReviewBloc;
    late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;
    late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
    late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
    late MockDownVoteRestaurantReviewUseCase
        mockDownVoteRestaurantReviewUseCase;

    setUp(() async {
      mockRestaurantDetailBloc = MockMockRestaurantDetailBloc();
      mockLocalAnalyticsObserver = MockMockLocalAnalyticsObserver();
      mockAnalyticsObserver = MockMockAnalyticsObserver();
      mockRestaurantPopularReviews = MockMockRestaurantPopularReviews();
      mockUserReviews = MockMockUserReviews();
      mockRestaurantPopularItemsBloc = MockMockRestaurantPopularItemsBloc();
      mockMapMarkersBloc = MockMockMapMarkersBloc();
      mockCartCubit = MockCartCubit();
      mockUserLocationBloc = MockUserLocationBloc();
      mockFavoriteBloc = MockFavoriteBloc();
      mockVideoPlayerController = MockVideoPlayerController();
      mockDeleteRestaurantReviewBloc = MockDeleteRestaurantReviewBloc();
      mockVoteOnReviewBloc = MockVoteOnReviewBloc();
      mockUpVoteItemReviewUseCase = MockUpVoteItemReviewUseCase();
      mockUpVoteRestaurantReviewUseCase = MockUpVoteRestaurantReviewUseCase();

      mockDownVoteItemReviewUseCase = MockDownVoteItemReviewUseCase();
      mockDownVoteRestaurantReviewUseCase =
          MockDownVoteRestaurantReviewUseCase();

      await dpLocator.reset();
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => MockMockAuthenticationLocalSource());
      dpLocator.registerFactory<RestaurantDetailBloc>(
          () => mockRestaurantDetailBloc);
      dpLocator.registerFactory<UserReviewsPageCubit>(() => mockUserReviews);
      dpLocator.registerFactory<RestaurantPopularReviewsBloc>(
          () => mockRestaurantPopularReviews);

      dpLocator.registerFactory<LocalAnalyticsObserver>(
        () => mockLocalAnalyticsObserver,
      );
      dpLocator.registerFactory<AnalyticsObserver>(
        () => mockAnalyticsObserver,
      );
      dpLocator.registerFactory<RestaurantPopularItemsBloc>(
          () => mockRestaurantPopularItemsBloc);
      dpLocator.registerFactory<MapMarkersBloc>(() => mockMapMarkersBloc);
      dpLocator.registerFactory<CartCubit>(() => mockCartCubit);
      dpLocator.registerFactory<UserLocationBloc>(() => mockUserLocationBloc);
      dpLocator.registerFactory<FavoriteBloc>(() => mockFavoriteBloc);
      dpLocator.registerFactory<VideoPlayerController>(
          () => mockVideoPlayerController);
      dpLocator.registerFactory<DeleteRestaurantReviewBloc>(
          () => mockDeleteRestaurantReviewBloc);
      dpLocator.registerFactory<VoteOnReviewBloc>(() => mockVoteOnReviewBloc);
      dpLocator.registerLazySingleton<UpVoteItemReviewUseCase>(
          () => mockUpVoteItemReviewUseCase);
      dpLocator.registerLazySingleton<UpVoteRestaurantReviewUseCase>(
          () => mockUpVoteRestaurantReviewUseCase);
      dpLocator.registerLazySingleton<DownVoteItemReviewUseCase>(
          () => mockDownVoteItemReviewUseCase);
      dpLocator.registerLazySingleton<DownVoteRestaurantReviewUseCase>(
          () => mockDownVoteRestaurantReviewUseCase);

      when(mockFavoriteBloc.state).thenAnswer((_) => FavoriteInitial());

      when(mockRestaurantDetailBloc.state).thenReturn(
        RestaurantDetailSuccess(
          restaurant: RestaurantModel(
            id: "id",
            restaurantLocations: [
              RestaurantLocation(latitude: 0.0, longitude: 0.0)
            ],
          ),
        ),
      );
      when(mockDeleteRestaurantReviewBloc.state).thenAnswer(
        (_) => DeleteRestaurantReviewInitial(),
      );
      when(mockVoteOnReviewBloc.state).thenAnswer(
        (_) => VoteOnReviewInitial(
          upVotes: 0,
          downVotes: 0,
          flag: 0,
        ),
      );

      HttpOverrides.global = null;
    });

    tearDown(() {
      dpLocator.reset();
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserReviewsPageCubit>(
              create: (contxt) => dpLocator<UserReviewsPageCubit>()),
          BlocProvider<RestaurantDetailBloc>(
            create: (context) => mockRestaurantDetailBloc,
          ),
          BlocProvider<RestaurantPopularReviewsBloc>(
              create: (context) => mockRestaurantPopularReviews),
          BlocProvider<RestaurantPopularItemsBloc>(
              create: (context) => mockRestaurantPopularItemsBloc),
          BlocProvider<MapMarkersBloc>(
              create: (context) => dpLocator<MapMarkersBloc>()),
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(),
          ),
          BlocProvider<UserLocationBloc>(
            create: (context) => mockUserLocationBloc,
          ),
          BlocProvider<FavoriteBloc>(
            create: (context) => mockFavoriteBloc,
          ),
          BlocProvider<DeleteRestaurantReviewBloc>(
            create: (context) => mockDeleteRestaurantReviewBloc,
          ),
          BlocProvider<VoteOnReviewBloc>(
            create: (context) => mockVoteOnReviewBloc,
          ),
        ],
        child: ResponsiveSizer(builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            locale: const Locale('en', 'US'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: ResponsiveSizer(builder: (context, orientation, screenType) {
              return body;
            }),
          );
        }),
      );
    }

    testWidgets('Should display loading animation when in loading state',
        (WidgetTester tester) async {
      when(mockRestaurantDetailBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockRestaurantDetailBloc.state)
          .thenAnswer((_) => RestaurantDetailLoading());

      await tester.pumpWidget(makeTestableWidget(const RestaurantDetail(
        restaurantId: 'restaurant_id',
      )));

      expect(
          find.byKey(
            const Key("Restaurant Detail Loading"),
          ),
          findsOneWidget);
    });

    testWidgets('Should display error message when in error state',
        (WidgetTester tester) async {
      when(mockRestaurantDetailBloc.state)
          .thenAnswer((_) => RestaurantDetailError(error: ''));

      await tester.pumpWidget(makeTestableWidget(const RestaurantDetail(
        restaurantId: 'restaurant_id',
      )));

      expect(
          find.byKey(
            const Key("Restaurant Detail Error"),
          ),
          findsOneWidget);
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display loading animation when in popular items loading state',
        (WidgetTester tester) async {
      when(mockRestaurantPopularItemsBloc.state)
          .thenAnswer((_) => RestaurantPopularItemsFetching());

      await tester.pumpWidget(
        makeTestableWidget(
          RestaurantDetail(
            restaurantId: 'restaurant_id',
            videoPlayerController: mockVideoPlayerController,
          ),
        ),
      );
      expect(find.byType(PopularItemsShimmerVertical), findsOneWidget);
      // expect(find.byKey(const Key("RestaurantItemsLoading")), findsOneWidget);
    });

    testWidgets('Should display result during success and empty',
        (WidgetTester tester) async {
      when(mockRestaurantPopularItemsBloc.state).thenAnswer(
          (_) => RestaurantPopularItemsFetched(popularItems: const []));

      await tester.pumpWidget(
        makeTestableWidget(
          RestaurantDetail(
            restaurantId: 'restaurant_id',
            videoPlayerController: mockVideoPlayerController,
          ),
        ),
      );
      expect(find.text('No popular items found'), findsOneWidget);
    });
    testWidgets('Should display result during success when the are items',
        (WidgetTester tester) async {
      when(mockRestaurantPopularItemsBloc.state).thenAnswer((_) =>
          RestaurantPopularItemsFetched(
              popularItems: const [RestaurantMenuItemModel()]));

      await tester.pumpWidget(makeTestableWidget(RestaurantDetail(
        restaurantId: 'restaurant_id',
        videoPlayerController: mockVideoPlayerController,
      )));
      expect(find.byType(PopularItemsPage), findsOneWidget);
    });
    testWidgets('Should display result in restaurant reviews loading state',
        (WidgetTester tester) async {
      when(mockRestaurantPopularReviews.state)
          .thenAnswer((_) => PopularRestaurantReviewsLoading());

      await tester.pumpWidget(makeTestableWidget(RestaurantDetail(
        videoPlayerController: mockVideoPlayerController,
        restaurantId: 'restaurant_id',
      )));
      expect(find.byType(RestaurantShimmerDisplay), findsOneWidget);
    });

    testWidgets(
        'Should display result during success Restaurant popular Reviews success',
        (WidgetTester tester) async {
      when(mockRestaurantPopularReviews.state).thenAnswer(
        (_) => PopularRestaurantReviewsLoaded(
          popularReviews: PopularRestaurantReviewsResponse(
            averageRating: 3.25,
            reviews: [
              PopularRestaurantReviewResponse(
                id: 'review_id',
                upVote: 0,
                downVote: 0,
                voted: 0,
              ),
            ],
            ratingsCount: [1, 1, 1, 1, 1],
            numberOfReviews: 10,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(RestaurantDetail(
        restaurantId: 'restaurant_id',
        videoPlayerController: mockVideoPlayerController,
      )));
      expect(
          find.byKey(
            Key("popular_restaurant_reviews_loaded_and_has_values"),
          ),
          findsOneWidget);
    });
    testWidgets(
        'Should display result during success Restaurant popular Reviews success but empty',
        (WidgetTester tester) async {
      when(mockRestaurantPopularReviews.state).thenAnswer(
        (_) => PopularRestaurantReviewsLoaded(
          popularReviews: PopularRestaurantReviewsResponse(
            averageRating: 3.25,
            reviews: [],
            ratingsCount: [0, 0, 0, 0, 0],
            numberOfReviews: 10,
          ),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(RestaurantDetail(
        restaurantId: 'restaurant_id',
        videoPlayerController: mockVideoPlayerController,
      )));
      expect(
          find.byKey(
            Key("popular_restaurant_reviews_loaded_and_empty"),
          ),
          findsOneWidget);
    });
  });
}
