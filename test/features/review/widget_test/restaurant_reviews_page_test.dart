import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_review_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_review_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'restaurant_reviews_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantReviewsBloc>(),
  MockSpec<DeleteRestaurantReviewBloc>(),
  MockSpec<RestaurantPopularReviewsBloc>(),
  MockSpec<RestaurantReviewsPageControllerCubit>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<DownVoteRestaurantReviewUseCase>(),
  MockSpec<UpVoteRestaurantReviewUseCase>(),
  MockSpec<DownVoteItemReviewUseCase>(),
  MockSpec<UpVoteItemReviewUseCase>(),
])
void main() {
  late MockGetRestaurantReviewsBloc mockGetRestaurantReviewsBloc;
  late MockDeleteRestaurantReviewBloc mockDeleteRestaurantReviewBloc;
  late MockRestaurantPopularReviewsBloc mockRestaurantPopularReviewsBloc;
  late MockRestaurantReviewsPageControllerCubit mockControllerCubit;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late MockDownVoteRestaurantReviewUseCase mockDownVoteRestaurantReviewUseCase;
  late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
  late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
  late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;

  setUp(() async {
    mockGetRestaurantReviewsBloc = MockGetRestaurantReviewsBloc();
    mockDeleteRestaurantReviewBloc = MockDeleteRestaurantReviewBloc();
    mockRestaurantPopularReviewsBloc = MockRestaurantPopularReviewsBloc();
    mockControllerCubit = MockRestaurantReviewsPageControllerCubit();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    mockDownVoteRestaurantReviewUseCase = MockDownVoteRestaurantReviewUseCase();
    mockUpVoteRestaurantReviewUseCase = MockUpVoteRestaurantReviewUseCase();
    mockDownVoteItemReviewUseCase = MockDownVoteItemReviewUseCase();
    mockUpVoteItemReviewUseCase = MockUpVoteItemReviewUseCase();

    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
    dpLocator.registerLazySingleton<DownVoteRestaurantReviewUseCase>(
        () => mockDownVoteRestaurantReviewUseCase);
    dpLocator.registerLazySingleton<UpVoteRestaurantReviewUseCase>(
        () => mockUpVoteRestaurantReviewUseCase);
    dpLocator.registerLazySingleton<DownVoteItemReviewUseCase>(
        () => mockDownVoteItemReviewUseCase);
    dpLocator.registerLazySingleton<UpVoteItemReviewUseCase>(
        () => mockUpVoteItemReviewUseCase);
    dpLocator.registerLazySingleton<GetRestaurantReviewsBloc>(
        () => mockGetRestaurantReviewsBloc);
    dpLocator.registerLazySingleton<DeleteRestaurantReviewBloc>(
        () => mockDeleteRestaurantReviewBloc);
    dpLocator.registerLazySingleton<RestaurantPopularReviewsBloc>(
        () => mockRestaurantPopularReviewsBloc);
    dpLocator.registerLazySingleton<RestaurantReviewsPageControllerCubit>(
        () => mockControllerCubit);
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<GetRestaurantReviewsBloc>.value(
      value: mockGetRestaurantReviewsBloc,
      child: BlocProvider<DeleteRestaurantReviewBloc>.value(
        value: mockDeleteRestaurantReviewBloc,
        child: BlocProvider<RestaurantPopularReviewsBloc>.value(
          value: mockRestaurantPopularReviewsBloc,
          child: BlocProvider<RestaurantReviewsPageControllerCubit>.value(
            value: mockControllerCubit,
            child: ResponsiveSizer(builder: (context, orientation, screenType) {
              SizeConfig().init(context);
              return MaterialApp(
                locale: const Locale('en', 'US'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: RestaurantReviewsPage(
                  restaurant: RestaurantModel(
                      id: 'restaurant123', name: 'Test Restaurant'),
                  loginRedirection: null,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  testWidgets('should initialize and fetch restaurant reviews on load',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    when(mockRestaurantPopularReviewsBloc.state).thenReturn(
      PopularRestaurantReviewsLoaded(
        popularReviews: PopularRestaurantReviewsResponse(
          reviews: [PopularRestaurantReviewResponse(id: "id")],
          ratingsCount: [1, 2, 0, 0, 0],
          averageRating: 3.5,
          numberOfReviews: 5,
        ),
      ),
    );

    // Verify that the initial event is dispatched to fetch restaurant reviews
    verify(mockGetRestaurantReviewsBloc.add(
            GetRestaurantReviewsRequestEvent(restaurantId: 'restaurant123')))
        .called(1);
  });

  testWidgets('should display Add Review button and user reviews text',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AddReview), findsOneWidget);
    expect(find.text('User reviews'), findsOneWidget);
  });

  testWidgets('should paginate when scrolled to the bottom',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Simulate the scroll reaching the bottom
    await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that pagination event is dispatched
    verify(mockGetRestaurantReviewsBloc.add(any)).called(1);
  });

  testWidgets('should display restaurant reviews', (WidgetTester tester) async {
    when(mockGetRestaurantReviewsBloc.state).thenReturn(
      GetRestaurantReviewsLoaded(
        sortType: RestaurantReviewsSortTypesState.mostPopular,
        reviews: RestaurantReviewsResponse(
          reviews: [RestaurantReviewResponse(id: "id")],
          ratingsCount: [1, 2, 0, 0, 0],
          averageRating: 3.5,
          numberOfReviews: 5,
        ),
      ),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('User reviews'), findsOneWidget);
  });
}
