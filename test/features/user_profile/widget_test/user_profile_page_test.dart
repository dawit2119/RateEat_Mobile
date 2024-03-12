import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_favorite.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/custom_tab_bar.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/profile_header.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/saved_review_card.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_favorite_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'test_data.dart';
import 'user_profile_page_test.mocks.dart';

class MockAuthenticationLocalSource extends Mock
    implements AuthenticationLocalSource {}

class MockGetUserProfileBloc extends Mock implements GetUserProfileBloc {}

class MockUserReviewBloc extends Mock implements UserReviewBloc {}

class MockSavedReviewsBloc extends Mock implements SavedReviewsBloc {}

class MockUserFavoriteBloc extends Mock implements UserFavoriteBloc {}

class MockLocalAnalyticsObserver extends Mock
    implements LocalAnalyticsObserver {}

class MockAnalyticsObserver extends Mock implements AnalyticsObserver {}

class MockRankBloc extends Mock implements RankBloc {}

class MockDeleteItemReviewBloc extends Mock implements DeleteItemReviewBloc {}

class MockDeleteRestaurantReviewBloc extends Mock
    implements DeleteRestaurantReviewBloc {}

class MockVoteOnReviewBloc extends Mock implements VoteOnReviewBloc {}

class MockUpVoteItemReviewUseCase extends Mock
    implements UpVoteItemReviewUseCase {}

class MockDownVoteItemReviewUseCase extends Mock
    implements DownVoteItemReviewUseCase {}

class MockUpVoteRestaurantReviewUseCase extends Mock
    implements UpVoteRestaurantReviewUseCase {}

class MockDownVoteRestaurantReviewUseCase extends Mock
    implements DownVoteRestaurantReviewUseCase {}

class MockRecommendationBloc extends Mock implements RecommendationBloc {}

class MockLocalProfileDataProvider extends Mock
    implements LocalProfileDataProvider {}

@GenerateNiceMocks([
  MockSpec<MockAuthenticationLocalSource>(),
  MockSpec<MockGetUserProfileBloc>(),
  MockSpec<MockUserReviewBloc>(),
  MockSpec<MockSavedReviewsBloc>(),
  MockSpec<MockUserFavoriteBloc>(),
  MockSpec<MockLocalAnalyticsObserver>(),
  MockSpec<MockAnalyticsObserver>(),
  MockSpec<MockRankBloc>(),
  MockSpec<MockDeleteItemReviewBloc>(),
  MockSpec<MockDeleteRestaurantReviewBloc>(),
  MockSpec<MockVoteOnReviewBloc>(),
  MockSpec<MockUpVoteItemReviewUseCase>(),
  MockSpec<MockDownVoteItemReviewUseCase>(),
  MockSpec<MockUpVoteRestaurantReviewUseCase>(),
  MockSpec<MockDownVoteRestaurantReviewUseCase>(),
  MockSpec<MockRecommendationBloc>(),
  MockSpec<MockLocalProfileDataProvider>(),
])
void main() {
  group('UserProfile Widget Test', () {
    late MockGetUserProfileBloc mockGetUserProfileBloc;
    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late MockUserReviewBloc mockUserReviewBloc;
    late MockSavedReviewsBloc mockSavedReviewsBloc;
    late MockUserFavoriteBloc mockUserFavoriteBloc;
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockRankBloc mockRankBloc;
    late MockDeleteItemReviewBloc mockDeleteItemReviewBloc;
    late MockDeleteRestaurantReviewBloc mockDeleteRestaurantReviewBloc;
    late MockVoteOnReviewBloc mockVoteOnReviewBloc;
    late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;
    late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
    late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
    late MockDownVoteRestaurantReviewUseCase
        mockDownVoteRestaurantReviewUseCase;
    late MockRecommendationBloc mockRecommendationBloc;
    late MockLocalProfileDataProvider mockLocalProfileDataProvider;

    setUp(() {
      dpLocator.reset();
      mockGetUserProfileBloc = MockMockGetUserProfileBloc();
      mockUserReviewBloc = MockMockUserReviewBloc();
      mockSavedReviewsBloc = MockMockSavedReviewsBloc();
      mockUserFavoriteBloc = MockMockUserFavoriteBloc();
      mockAuthenticationLocalSource = MockMockAuthenticationLocalSource();
      mockLocalAnalyticsObserver = MockLocalAnalyticsObserver();
      mockAnalyticsObserver = MockAnalyticsObserver();
      mockRankBloc = MockMockRankBloc();
      mockDeleteItemReviewBloc = MockMockDeleteItemReviewBloc();
      mockDeleteRestaurantReviewBloc = MockMockDeleteRestaurantReviewBloc();
      mockVoteOnReviewBloc = MockMockVoteOnReviewBloc();
      mockUpVoteItemReviewUseCase = MockMockUpVoteItemReviewUseCase();
      mockDownVoteItemReviewUseCase = MockMockDownVoteItemReviewUseCase();
      mockUpVoteRestaurantReviewUseCase =
          MockMockUpVoteRestaurantReviewUseCase();
      mockDownVoteRestaurantReviewUseCase =
          MockMockDownVoteRestaurantReviewUseCase();
      mockRecommendationBloc = MockMockRecommendationBloc();

      mockLocalProfileDataProvider = MockMockLocalProfileDataProvider();

      // Registering the mocks with the dependency locator
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => MockMockAuthenticationLocalSource(),
      );

      dpLocator.registerFactory<GetUserProfileBloc>(
        () => mockGetUserProfileBloc,
      );

      dpLocator.registerFactory<LocalProfileDataProvider>(
        () => mockLocalProfileDataProvider,
      );

      dpLocator.registerFactory<RecommendationBloc>(
        () => mockRecommendationBloc,
      );
      dpLocator.registerFactory<UserReviewBloc>(
        () => mockUserReviewBloc,
      );
      dpLocator.registerFactory<SavedReviewsBloc>(
        () => mockSavedReviewsBloc,
      );
      dpLocator.registerFactory<UserFavoriteBloc>(
        () => mockUserFavoriteBloc,
      );
      dpLocator.registerFactory<LocalAnalyticsObserver>(
        () => mockLocalAnalyticsObserver,
      );
      dpLocator.registerFactory<AnalyticsObserver>(
        () => mockAnalyticsObserver,
      );
      dpLocator.registerFactory<RankBloc>(
        () => mockRankBloc,
      );
      dpLocator.registerFactory<DeleteItemReviewBloc>(
        () => mockDeleteItemReviewBloc,
      );
      dpLocator.registerFactory<DeleteRestaurantReviewBloc>(
        () => mockDeleteRestaurantReviewBloc,
      );
      dpLocator.registerFactory<VoteOnReviewBloc>(
        () => mockVoteOnReviewBloc,
      );
      dpLocator.registerFactory<UpVoteItemReviewUseCase>(
        () => mockUpVoteItemReviewUseCase,
      );
      dpLocator.registerFactory<DownVoteItemReviewUseCase>(
        () => mockDownVoteItemReviewUseCase,
      );
      dpLocator.registerFactory<UpVoteRestaurantReviewUseCase>(
        () => mockUpVoteRestaurantReviewUseCase,
      );
      dpLocator.registerFactory<DownVoteRestaurantReviewUseCase>(
        () => mockDownVoteRestaurantReviewUseCase,
      );

      SizeConfig.blockSizeVertical = 8;
      SizeConfig.screenWidth = 1000;
      SizeConfig.screenHeight = 2000;
      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => dpLocator<UserReviewsPageCubit>()),
          BlocProvider(
            create: (context) => dpLocator<GetUserProfileBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<UserReviewBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<SavedReviewsBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<UserFavoriteBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<RankBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<DeleteItemReviewBloc>(),
          ),
          BlocProvider(
            create: (context) => dpLocator<DeleteRestaurantReviewBloc>(),
          ),
          BlocProvider(create: (context) => dpLocator<RecommendationBloc>()),
          BlocProvider(
            // create: (context) => dpLocator<VoteOnReviewBloc>(),
            create: (context) => VoteOnReviewBloc(
              const VoteOnReviewInitial(
                upVotes: 10,
                downVotes: 20,
                flag: 5,
              ),
              upVoteItemReviewUseCase: dpLocator<UpVoteItemReviewUseCase>(),
              downVoteItemReviewUseCase: dpLocator<DownVoteItemReviewUseCase>(),
              upVoteRestaurantReviewUseCase:
                  dpLocator<UpVoteRestaurantReviewUseCase>(),
              downVoteRestaurantReviewUseCase:
                  dpLocator<DownVoteRestaurantReviewUseCase>(),
            ),
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

    testWidgets('Should display loading animation when profile is loading',
        (WidgetTester tester) async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(
        LocalUserModel(id: '123'),
      );

      when(mockGetUserProfileBloc.state).thenReturn(UserProfileLoading());

      await tester.pumpWidget(makeTestableWidget(UserProfile()));
      expect(
        find.byKey(
          Key("Loading Center Widget"),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          Key("Loading Animation Widget"),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Should display error message when profile fails to load',
        (WidgetTester tester) async {
      when(mockGetUserProfileBloc.state).thenAnswer(
          (_) => GetUserProfileError(error: "Error loading profile"));

      await tester.pumpWidget(makeTestableWidget(UserProfile()));

      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display user profile information when profile is loaded',
        (WidgetTester tester) async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(
        LocalUserModel(id: '123'),
      );

      when(mockGetUserProfileBloc.state).thenAnswer(
          (_) => UserProfileLoaded(user: dummyUser, isLocalData: false));

      await tester.pumpWidget(makeTestableWidget(UserProfile()));

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.byKey(Key('Profile Loaded Widget')), findsOneWidget);
    });

    testWidgets('Should handle swipe to refresh', (WidgetTester tester) async {
      when(mockLocalProfileDataProvider.getProfileData())
          .thenAnswer((_) async => dummyUser);

      when(mockLocalProfileDataProvider.cacheProfileData(dummyUser)).thenAnswer(
        (_) async {},
      );
      when(mockGetUserProfileBloc.state).thenAnswer((_) => UserProfileLoaded(
            isLocalData: false,
            user: dummyUser,
          ));

      await tester.pumpWidget(makeTestableWidget(const UserProfile()));
      // await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.byKey(Key('Profile Loaded Widget')), findsOneWidget);
    });

    testWidgets('Should display user reviews when reviews are loaded',
        (WidgetTester tester) async {
      when(mockGetUserProfileBloc.state).thenAnswer(
          (_) => UserProfileLoaded(user: dummyUser, isLocalData: false));
      when(mockUserReviewBloc.state).thenAnswer(
        (_) => UserReviewLoaded(
            userReviews: dummyUserReviews,
            hasReachedMax: false,
            isLocalData: false,
            page: 1),
      );

      await tester.pumpWidget(makeTestableWidget(const UserProfile()));
      expect(find.byType(UserReviewCard), findsWidgets);
      expect(find.byType(CustomScrollView), findsWidgets);
    });

    testWidgets('Should display a message when no reviews are found',
        (WidgetTester tester) async {
      when(mockLocalProfileDataProvider.getProfileData())
          .thenAnswer((_) async => dummyUser);

      when(mockLocalProfileDataProvider.cacheProfileData(dummyUser)).thenAnswer(
        (_) async {},
      );

      when(mockGetUserProfileBloc.state).thenAnswer(
        (_) => UserProfileLoaded(user: dummyUser, isLocalData: false),
      );

      when(mockUserReviewBloc.state).thenAnswer((_) => UserReviewLoaded(
          userReviews: [], hasReachedMax: true, isLocalData: false, page: 1));

      await tester.pumpWidget(makeTestableWidget(const UserProfile()));
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    // testWidgets('Should display saved reviews when they are loaded',
    //     (WidgetTester tester) async {
    //   when(mockLocalProfileDataProvider.getProfileData()).thenAnswer(
    //     (_) async => dummyUser,
    //   );

    //   when(mockLocalProfileDataProvider.cacheProfileData(dummyUser)).thenAnswer(
    //     (_) async => null,
    //   );
    //   when(mockGetUserProfileBloc.state).thenAnswer(
    //     (_) => UserProfileLoaded(user: dummyUser, isLocalData: false),
    //   );
    //   when(mockSavedReviewsBloc.state).thenReturn(
    //     SavedReviewLoaded(
    //       isLocalData: false,
    //       savedReviews: List.generate(
    //         10,
    //         (index) => SavedReviewsResponseModel(draftId: "$index"),
    //       ),
    //       page: 1,
    //       hasReachedMax: false,
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   expect(
    //     find.byType(DraftReviewCard),
    //     findsOneWidget,
    //   );
    //   // Adjust the expectations based on your implementation
    // });

    // testWidgets('Should display favorite items when they are loaded',
    //     (WidgetTester tester) async {
    //   when(mockGetUserProfileBloc.state).thenAnswer(
    //     (_) => UserProfileLoaded(user: dummyUser,isLocalData: false),
    //   );
    //   when(mockUserFavoriteBloc.state).thenAnswer(
    //     (_) => UserFavoritesLoading(),
    //   );

    //   when(mockUserFavoriteBloc.state).thenAnswer(
    //     (_) => UserFavoritesLoaded(
    //       isLocalData: false,
    //       favorites: List.generate(
    //         10,
    //         (index) => UserFavorite(id: "$index"),
    //       ),
    //     ),
    //   );

    //   await tester.pumpWidget(makeTestableWidget(const UserProfile()));
    //   expect(find.byType(UserFavoriteItemsShimmer), findsWidgets);
    // });
  });
}
