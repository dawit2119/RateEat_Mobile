import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_review_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'item_reviews_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemReviewsBloc>(),
  MockSpec<DeleteItemReviewBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<ItemReviewsPageControllerCubit>(),
  MockSpec<DownVoteRestaurantReviewUseCase>(),
  MockSpec<UpVoteRestaurantReviewUseCase>(),
  MockSpec<DownVoteItemReviewUseCase>(),
  MockSpec<UpVoteItemReviewUseCase>(),
])
void main() {
  late MockGetItemReviewsBloc mockGetItemReviewsBloc;
  late MockDeleteItemReviewBloc mockDeleteItemReviewBloc;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late MockItemReviewsPageControllerCubit mockItemReviewsPageControllerCubit;
  late MockDownVoteRestaurantReviewUseCase mockDownVoteRestaurantReviewUseCase;
  late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
  late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
  late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;

  setUp(() async {
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    mockItemReviewsPageControllerCubit = MockItemReviewsPageControllerCubit();
    mockGetItemReviewsBloc = MockGetItemReviewsBloc();
    mockDeleteItemReviewBloc = MockDeleteItemReviewBloc();
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
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<GetItemReviewsBloc>.value(
      value: mockGetItemReviewsBloc,
      child: BlocProvider<DeleteItemReviewBloc>.value(
        value: mockDeleteItemReviewBloc,
        child: BlocProvider<ItemReviewsPageControllerCubit>.value(
          value: mockItemReviewsPageControllerCubit,
          child: ResponsiveSizer(builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return MaterialApp(
              locale: const Locale('en', 'US'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: ItemReviewsPage(
                item: ItemModel(
                  itemId: 'item123',
                  itemName: 'Test Item',
                  numberOfReviews: 0,
                ),
                loginRedirection: null,
              ),
            );
          }),
        ),
      ),
    );
  }

  testWidgets('should initialize and fetch item reviews on load',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify that the initial event is dispatched to fetch item reviews
    verify(mockGetItemReviewsBloc
            .add(GetItemReviewsRequestEvent(itemId: 'item123')))
        .called(1);
  });

  testWidgets('should display Add Review button and user reviews text',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(AddReview), findsOneWidget);
    expect(find.text('User reviews'), findsOneWidget);
  });

  testWidgets('should listen for DeleteItemReviewBloc state changes',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Simulate the DeleteItemReviewSuccess state
    when(mockDeleteItemReviewBloc.state).thenReturn(
        DeleteItemReviewSuccess(message: 'Review deleted successfully'));
    await tester.pump(); // Rebuild with the new state

    // Verify the appropriate actions are taken on success
    verify(mockGetItemReviewsBloc
            .add(GetItemReviewsRequestEvent(itemId: 'item123')))
        .called(1);
  });

  testWidgets('should paginate when scrolled to the bottom',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Simulate the scroll reaching the bottom
    await tester.drag(find.byType(SingleChildScrollView), Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify that pagination event is dispatched
    verify(mockGetItemReviewsBloc.add(any)).called(1);
  });

  testWidgets('should display item reviews', (WidgetTester tester) async {
    when(mockGetItemReviewsBloc.state).thenReturn(
      GetItemReviewsLoaded(
        sortType: ItemReviewsSortTypesState.mostPopular,
        reviews: ItemReviewsResponse(
          reviews: [ItemReviewResponse(id: "id")],
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
