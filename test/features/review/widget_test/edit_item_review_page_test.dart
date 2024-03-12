import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/edit_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_item_review/edit_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'edit_item_review_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<EditItemReviewBloc>(),
  MockSpec<UserReviewBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<ImagePicker>(),
])
void main() {
  late MockEditItemReviewBloc mockEditItemReviewBloc;
  late MockUserReviewBloc mockUserReviewBloc;
  late MockAuthenticationLocalSource authenticationLocalSource;
  late MockImagePicker mockImagePicker;

  setUp(() async {
    await dpLocator.reset();
    authenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => authenticationLocalSource);
    mockEditItemReviewBloc = MockEditItemReviewBloc();
    mockUserReviewBloc = MockUserReviewBloc();
    mockImagePicker = MockImagePicker();
    dpLocator.registerLazySingleton<EditItemReviewBloc>(
        () => mockEditItemReviewBloc);
    dpLocator.registerLazySingleton<ImagePicker>(() => mockImagePicker);
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<EditItemReviewBloc>.value(
      value: mockEditItemReviewBloc,
      child: BlocProvider<UserReviewBloc>.value(
        value: mockUserReviewBloc,
        child: ResponsiveSizer(builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: EditItemReviewPage(
              imagePicker: mockImagePicker,
              item: ItemModel(
                itemId: "id",
                itemName: "name",
                numberOfReviews: 0,
              ),
              reviewId: 'review123',
              reviewContent: PopularItemReviewResponse(
                id: "id",
                comment: 'Initial Comment',
                images: [],
                videos: [],
              ),
            ),
          );
        }),
      ),
    );
  }

  testWidgets('should display initial comment and rating',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Initial Comment'), findsOneWidget);
    expect(find.byType(StarRatingInput), findsOneWidget);
  });

  testWidgets('should call pickMultipleMedia when the upload button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    when(mockImagePicker.pickMultipleMedia(
            imageQuality: anyNamed('imageQuality')))
        .thenAnswer((_) async => [
              XFile('assets/images/add_review.png'),
              XFile('assets/images/add_review.png'),
              XFile('assets/images/add_review.png'),
            ]);

    final uploadButton = find.byType(InkWell).first;
    await tester.tap(uploadButton);
    await tester.pump(Duration(milliseconds: 500));

    verify(
      mockImagePicker.pickMultipleMedia(
        imageQuality: anyNamed('imageQuality'),
      ),
    ).called(1);
    expect(find.byType(SelectedImageDisplay), findsNWidgets(3));
  });

  testWidgets('should show loading button when in loading state',
      (WidgetTester tester) async {
    when(mockEditItemReviewBloc.state).thenReturn(EditItemReviewLoading());
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoadingButton), findsOneWidget);
  });

  testWidgets('should update the review when the submit button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Change rating and comment
    await tester.tap(find.byType(StarRatingInput));
    await tester.enterText(find.byType(InputTextfield), 'Updated Comment');

    final submitButton = find.byType(SubmitButton);
    await tester.tap(submitButton);

    // Verify that the EditItemReviewRequestEvent was triggered
    verify(mockEditItemReviewBloc.add(any)).called(1);
  });
}
