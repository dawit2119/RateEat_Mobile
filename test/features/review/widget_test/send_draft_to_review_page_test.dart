import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/send_draft_to_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/draft_to_review/draft_to_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_item_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'send_draft_to_review_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DraftToReviewBloc>(),
  MockSpec<SavedReviewsBloc>(),
  MockSpec<GetUserProfileBloc>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() {
  late MockDraftToReviewBloc mockDraftToReviewBloc;
  late MockSavedReviewsBloc mockSavedReviewsBloc;
  late MockGetUserProfileBloc mockUserProfileBloc;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;

  setUp(() async {
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    mockDraftToReviewBloc = MockDraftToReviewBloc();
    mockSavedReviewsBloc = MockSavedReviewsBloc();
    mockUserProfileBloc = MockGetUserProfileBloc();
    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
    dpLocator
        .registerLazySingleton<DraftToReviewBloc>(() => mockDraftToReviewBloc);
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<DraftToReviewBloc>.value(
      value: mockDraftToReviewBloc,
      child: BlocProvider<SavedReviewsBloc>.value(
        value: mockSavedReviewsBloc,
        child: BlocProvider<GetUserProfileBloc>.value(
          value: mockUserProfileBloc,
          child: ResponsiveSizer(builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return MaterialApp(
              locale: const Locale('en', 'US'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: SendDraftToReviewPage(
                reviewContent: SavedReviewsResponseModel(
                  images: <DraftFileContentModel>[],
                  videos: <DraftFileContentModel>[],
                  item: SavedReviewItemResponseModel(
                    itemId: "1",
                    itemName: "item name",
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  testWidgets('should initialize with correct review content',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Write a review'), findsOneWidget);
  });

  testWidgets(
      'should dispatch SendDraftToReviewEvent when submit button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Simulate entering a comment
    await tester.enterText(find.byType(InputTextfield), 'Great item!');

    final submitButton = find.byType(SubmitButton);
    await tester.tap(submitButton);

    // Verify that the SendDraftToReviewEvent was dispatched
    verify(mockDraftToReviewBloc.add(any)).called(1);
  });

  testWidgets('should display loading button when loading state',
      (WidgetTester tester) async {
    when(mockDraftToReviewBloc.state).thenReturn(DraftToReviewLoading());
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoadingButton), findsOneWidget);
  });
}
