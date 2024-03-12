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
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/menu.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/image_and_video_highlight.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/item_review_shimmer_display.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/custom_tab_bar.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

import 'item_detail_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemDetailBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<LocalAnalyticsObserver>(),
  MockSpec<AnalyticsObserver>(),
  MockSpec<PopularItemReviewsBloc>(),
  MockSpec<DetailRecommendationBloc>(),
  MockSpec<FavoriteBloc>(),
  MockSpec<VideoPlayerController>(),
  MockSpec<UserReviewsPageCubit>(),
  MockSpec<DeleteItemReviewBloc>(),
  MockSpec<VoteOnReviewBloc>(),
  MockSpec<UpVoteItemReviewUseCase>(),
  MockSpec<DownVoteItemReviewUseCase>(),
  MockSpec<UpVoteRestaurantReviewUseCase>(),
  MockSpec<DownVoteRestaurantReviewUseCase>(),
])
void main() {
  late MockItemDetailBloc mockItemDetailBloc;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
  late MockAnalyticsObserver mockAnalyticsObserver;
  late MockPopularItemReviewsBloc mockPopularItemReviewsBloc;
  late MockDetailRecommendationBloc mockDetailRecommendationBloc;
  late MockFavoriteBloc mockFavoriteBloc;
  late MockVideoPlayerController mockVideoPlayerController;
  late MockUserReviewsPageCubit mockUserReviewsPageCubit;
  late MockDeleteItemReviewBloc mockDeleteItemReviewBloc;
  late MockVoteOnReviewBloc mockVoteOnReviewBloc;
  late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;
  late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
  late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
  late MockDownVoteRestaurantReviewUseCase mockDownVoteRestaurantReviewUseCase;

  setUp(() async {
    HttpOverrides.global = null;
    mockItemDetailBloc = MockItemDetailBloc();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    mockLocalAnalyticsObserver = MockLocalAnalyticsObserver();
    mockAnalyticsObserver = MockAnalyticsObserver();
    mockPopularItemReviewsBloc = MockPopularItemReviewsBloc();
    mockDetailRecommendationBloc = MockDetailRecommendationBloc();
    mockFavoriteBloc = MockFavoriteBloc();
    mockVideoPlayerController = MockVideoPlayerController();
    mockUserReviewsPageCubit = MockUserReviewsPageCubit();
    mockDeleteItemReviewBloc = MockDeleteItemReviewBloc();
    mockVoteOnReviewBloc = MockVoteOnReviewBloc();
    mockUpVoteItemReviewUseCase = MockUpVoteItemReviewUseCase();
    mockDownVoteItemReviewUseCase = MockDownVoteItemReviewUseCase();
    mockDownVoteRestaurantReviewUseCase = MockDownVoteRestaurantReviewUseCase();
    mockUpVoteRestaurantReviewUseCase = MockUpVoteRestaurantReviewUseCase();

    when(mockDeleteItemReviewBloc.state).thenReturn(DeleteItemReviewInitial());
    when(mockVoteOnReviewBloc.state).thenReturn(VoteOnReviewInitial(
      upVotes: 0,
      flag: 0,
      downVotes: 0,
    ));
    when(mockVoteOnReviewBloc.stream)
        .thenAnswer((_) => Stream.value(VoteOnReviewInitial(
              upVotes: 0,
              flag: 0,
              downVotes: 0,
            )));

    await dpLocator.reset();

    dpLocator.registerFactory<FavoriteBloc>(
      () => mockFavoriteBloc,
    );
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
      () => mockAuthenticationLocalSource,
    );
    dpLocator.registerFactory<ItemDetailBloc>(
      () => mockItemDetailBloc,
    );
    dpLocator.registerFactory<LocalAnalyticsObserver>(
      () => mockLocalAnalyticsObserver,
    );
    dpLocator.registerFactory<AnalyticsObserver>(
      () => mockAnalyticsObserver,
    );
    dpLocator.registerFactory<PopularItemReviewsBloc>(
      () => mockPopularItemReviewsBloc,
    );
    dpLocator.registerFactory<DetailRecommendationBloc>(
      () => mockDetailRecommendationBloc,
    );
    dpLocator.registerFactory<UserReviewsPageCubit>(
      () => mockUserReviewsPageCubit,
    );
    dpLocator.registerFactory<DeleteItemReviewBloc>(
      () => mockDeleteItemReviewBloc,
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

    when(mockVoteOnReviewBloc.add(any)).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserReviewsPageCubit>(
          create: (context) => dpLocator<UserReviewsPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FavoriteBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<ItemDetailBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<PopularItemReviewsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DetailRecommendationBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DeleteItemReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<VoteOnReviewBloc>(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en', 'US'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResponsiveSizer(builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return body;
        }),
      ),
    );
  }

  const itemId = '1';
  final item = ItemModel(
    itemId: '1',
    itemName: 'itemName',
    numberOfReviews: 5,
    description: "",
    ingredients: const [Ingredient(id: "ing_id", name: "ing_name")],
    averageRating: 0.0,
    price: 134,
    imageUrl:
        "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
    itemImages: const [
      ItemMedia(
          id: "id 1",
          url:
              "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
    ],
    itemVideos: const [],
    restaurantName: '',
    tags: const [''],
    categoryId: "",
    fasting: false,
    createdAt: DateTime.parse('2022-01-01 00:00:00.000Z'),
    updatedAt: DateTime.parse('2022-01-01 00:00:00.000Z'),
    categories: const Categories(
      menu: Menu(
        id: '1',
        restaurant: Restaurant(
          id: '1',
          name: 'restaurant',
        ),
      ),
      menuId: '1',
    ),
    minutes: 0,
    isOpen: false,
    isFavorite: false,
    distance: "0.0",
    walkingTime: "",
    ridingTime: "",
  );

  group('itemDetails', () {
    testWidgets(
      'should render ItemDetailInitial',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            itemId: itemId,
            videoController: mockVideoPlayerController,
          )),
        );
        expect(find.byType(Container), findsOneWidget);
      },
    );

    testWidgets(
      'should render ItemDetailLoading',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state).thenReturn(ItemDetailLoading());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            itemId: itemId,
            videoController: mockVideoPlayerController,
          )),
        );
        expect(find.byKey(const Key('item_detail_loading')), findsOneWidget);
        expect(find.text("Getting item details"), findsOneWidget);
      },
    );
    testWidgets(
      'should render ItemDetailSuccess',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(HorizontalHighlight), findsOneWidget);
        expect(find.byKey(const Key('item_detail_info')), findsOneWidget);
        expect(find.text("itemName"), findsOneWidget);
      },
    );

    testWidgets(
      'should render ItemDetailSuccess renders description',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state).thenReturn(
          ItemDetailSuccess(
            item: ItemModel(
              itemId: "itemId",
              itemName: "itemName",
              numberOfReviews: 0,
              description: "item description",
            ),
            isLocal: false,
          ),
        );
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byType(CustomScrollView), findsOneWidget);
        expect(find.byType(HorizontalHighlight), findsOneWidget);
        expect(find.byKey(const Key('item_detail_info')), findsOneWidget);
        expect(find.text("itemName"), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('item description'), findsOneWidget);
      },
    );

    testWidgets(
      'should render ItemDetailError',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailError(error: "Error"));
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
        expect(find.text("Unknown error. Please try again"), findsOneWidget);
      },
    );
  });

  group("item detail when item passed from params", () {
    testWidgets('should render item details from parameter',
        (WidgetTester tester) async {
      // arrange
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(
              itemId: "id",
              itemName: "name",
              numberOfReviews: 1,
              description: "item description"),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(find.byKey(Key('item_detail_rendered_from_parameter')),
          findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('item description'), findsOneWidget);
    });

    testWidgets(
        'should render popular reviews is empty and item passed through params',
        (WidgetTester tester) async {
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      when(mockPopularItemReviewsBloc.state).thenReturn(
        PopularItemReviewsLoaded(
          popularReviews: PopularItemReviewsResponse(
            ratingsCount: [],
            reviews: [],
            averageRating: 0.0,
            numberOfReviews: 0,
          ),
          isLocal: false,
        ),
      );
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(itemId: "id", itemName: "name", numberOfReviews: 1),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(find.byKey(Key("popular_review_is_empty_item_from_param")),
          findsOneWidget);
    });

    testWidgets(
        'should render popular reviews is not empty and item passed through params',
        (WidgetTester tester) async {
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      when(mockPopularItemReviewsBloc.state).thenReturn(
        PopularItemReviewsLoaded(
          popularReviews: PopularItemReviewsResponse(
            ratingsCount: [],
            reviews: [
              PopularItemReviewResponse(
                id: "id",
                voted: 0,
                upVote: 0,
                downVote: 0,
              ),
            ],
            averageRating: 0.0,
            numberOfReviews: 0,
          ),
          isLocal: false,
        ),
      );
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(itemId: "id", itemName: "name", numberOfReviews: 10),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(
          find.byKey(
              Key("popular_review_loaded_and_not_empty_with_item_from_param")),
          findsOneWidget);
    });

    testWidgets('should render recommended when items passed through params',
        (WidgetTester tester) async {
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      when(mockDetailRecommendationBloc.state).thenReturn(
          DetailRecommendedSuccess(recommendations: [
        ItemModel(itemId: "itemId", itemName: "itemName", numberOfReviews: 5)
      ], isLocal: false));
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(itemId: "id", itemName: "name", numberOfReviews: 1),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(
          find.byKey(Key(
              'recommended_items_not_empty_when_item_passed_through_params')),
          findsOneWidget);
    });

    testWidgets(
        'should render recommended when items passed through params and no recommended item is found',
        (WidgetTester tester) async {
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      when(mockDetailRecommendationBloc.state).thenReturn(
          DetailRecommendedSuccess(recommendations: [], isLocal: false));
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(itemId: "id", itemName: "name", numberOfReviews: 1),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(
          find.byKey(
              Key('recommended_items_empty_when_item_passed_through_params')),
          findsOneWidget);
    });
    testWidgets('should render recommended failed items passed through params',
        (WidgetTester tester) async {
      when(mockItemDetailBloc.state).thenReturn(ItemDetailInitial());
      when(mockDetailRecommendationBloc.state).thenReturn(
          DetailRecommendedError(error: "failed to load recommendations"));
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          itemId: itemId,
          item: ItemModel(itemId: "id", itemName: "name", numberOfReviews: 1),
          videoController: mockVideoPlayerController,
        )),
      );
      expect(
          find.byKey(
              Key('recommended_items_failed_when_item_passed_through_params')),
          findsOneWidget);
    });
  });

  group('PopularItemReviews', () {
    testWidgets(
      'should render PopularItemReviewsInitial',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockPopularItemReviewsBloc.state)
            .thenReturn(PopularItemReviewsInitial());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byKey(const Key('item_detail_popular_reviews_initial')),
            findsOneWidget);
      },
    );

    testWidgets(
      'should render PopularItemReviewsLoading',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockPopularItemReviewsBloc.state)
            .thenReturn(PopularItemReviewLoading());
        when(mockFavoriteBloc.state).thenReturn(const FavoriteAdded());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byType(ReviewItemShimmerDisplay), findsOneWidget);
      },
    );
    testWidgets(
      'should render PopularItemReviewsLoaded',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockPopularItemReviewsBloc.state).thenReturn(
          PopularItemReviewsLoaded(
              isLocal: false,
              popularReviews: PopularItemReviewsResponse(ratingsCount: [
                0,
                0,
                0,
                0,
                0
              ], reviews: [
                PopularItemReviewResponse(
                    id: "id",
                    upVote: 1,
                    downVote: 1,
                    voted: 0,
                    user: PopularItemReviewerProfileResponse(
                        id: "id",
                        firstName: "firstName",
                        lastName: "lastName",
                        image: "image"))
              ], averageRating: 0, numberOfReviews: 0)),
        );
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(
            find.byKey(
              const Key("popular_review_loaded_and_not_empty"),
            ),
            findsOneWidget);
        expect(find.text("User reviews"), findsOneWidget);
      },
    );

    testWidgets(
      'should render PopularItemReviewsLoaded but is empty when there is no review',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockPopularItemReviewsBloc.state).thenReturn(
          PopularItemReviewsLoaded(
              isLocal: false,
              popularReviews: PopularItemReviewsResponse(
                  ratingsCount: [0, 0, 0, 0, 0],
                  reviews: [],
                  averageRating: 0,
                  numberOfReviews: 0)),
        );
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(
            find.byKey(
              const Key("popular_review_loaded_and_is_empty"),
            ),
            findsOneWidget);
        expect(find.text("User reviews"), findsOneWidget);
      },
    );

    // testWidgets(
    //   'should render PopularItemReviewsFailure',
    //   (WidgetTester tester) async {
    //     // arrange
    //     when(mockPopularItemReviewsBloc.state)
    //         .thenReturn(PopularItemReviewsFailure(message: "Error"));
    //     when(mockItemDetailBloc.state).thenReturn(ItemDetailSuccess(
    //         item: ItemModel(
    //             itemId: "itemId", itemName: "itemName", numberOfReviews: 0),
    //         isLocal: false));
    //     // act
    //     await tester.pumpWidget(
    //       makeTestableWidget(ItemDetail(
    //         videoController: mockVideoPlayerController,
    //         itemId: itemId,
    //       )),
    //     );
    //     await tester.pump(Duration(seconds: 1));
    //     expect(find.byKey(const Key('item_detail_popular_reviews_failure')),
    //         findsOneWidget);
    //     expect(find.byType(ElevatedButton), findsOneWidget);
    //     expect(find.text("Could not load reviews"), findsOneWidget);
    //   },
    // );
  });

  group('DetailRecommendation', () {
    testWidgets(
      'should render DetailRecommendationInitial',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockDetailRecommendationBloc.state)
            .thenReturn(DetailRecommendedInitial());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byKey(Key("initial_state_for_item_detail_recommendations")),
            findsOneWidget);
      },
    );

    testWidgets(
      'should render DetailRecommendationLoading',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockDetailRecommendationBloc.state)
            .thenReturn(DetailRecommendedLoading());
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(find.byType(PopularItemsShimmerHorizontal), findsOneWidget);
      },
    );
    testWidgets(
      'should render DetailRecommendedSuccess',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockDetailRecommendationBloc.state)
            .thenReturn(DetailRecommendedSuccess(recommendations: const [
          ItemModel(
            itemId: "id",
            itemName: "item name",
            numberOfReviews: 0,
          ),
        ], isLocal: false));
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(
            find.byKey(Key("item_detail_recommendations_loaded_and_not_empty")),
            findsOneWidget);
        expect(find.text("Recommended"), findsOneWidget);
      },
    );

    testWidgets(
      'should render DetailRecommendedSuccess empty state',
      (WidgetTester tester) async {
        // arrange
        when(mockItemDetailBloc.state)
            .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
        when(mockDetailRecommendationBloc.state).thenReturn(
            DetailRecommendedSuccess(
                recommendations: const [], isLocal: false));
        // act
        await tester.pumpWidget(
          makeTestableWidget(ItemDetail(
            videoController: mockVideoPlayerController,
            itemId: itemId,
          )),
        );
        await tester.pump(Duration(seconds: 1));
        expect(
            find.byKey(Key("item_detail_recommendations_loaded_and_is_empty")),
            findsOneWidget);
        expect(find.text("No recommendations found"), findsOneWidget);
      },
    );

    testWidgets('should render DetailRecommendedError',
        (WidgetTester tester) async {
      // arrange
      when(mockItemDetailBloc.state)
          .thenReturn(ItemDetailSuccess(item: item, isLocal: false));
      when(mockDetailRecommendationBloc.state)
          .thenReturn(DetailRecommendedError(error: "Error"));
      // act
      await tester.pumpWidget(
        makeTestableWidget(ItemDetail(
          videoController: mockVideoPlayerController,
          itemId: itemId,
        )),
      );
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(const Key('item_detail_recommended_items_failure')),
          findsOneWidget);
    });
  });
}
