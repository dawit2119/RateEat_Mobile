import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_state.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/screens/candidate_restaurant_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_input_field.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'candidate_restaurant_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CandidateBloc>(),
  MockSpec<ImagePicker>(),
])
void main() {
  late MockCandidateBloc mockCandidateBloc;
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockCandidateBloc = MockCandidateBloc();
    mockImagePicker = MockImagePicker();
  });

  Widget createWidgetUnderTest() {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      SizeConfig().init(context);
      return BlocProvider<CandidateBloc>.value(
        value: mockCandidateBloc,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CandidateRestaurantPage(
            picker: mockImagePicker,
          ),
        ),
      );
    });
  }

  testWidgets('CandidateRestaurantPage initializes correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Suggest Restaurant'), findsOneWidget);
    expect(find.byType(PriceTextField), findsNWidgets(2));
    expect(find.byType(SubmitButton), findsOneWidget);
  });

  testWidgets('Submit button is initially disabled',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final submitButton = find.byType(SubmitButton);
    expect(submitButton, findsOneWidget);
    expect(tester.widget<SubmitButton>(submitButton).onClick, isNull);
  });

  testWidgets(
      'Submit button becomes enabled when name is entered and images are selected',
      (WidgetTester tester) async {
    when(mockImagePicker.pickMultiImage(imageQuality: 20))
        .thenAnswer((_) async {
      return [
        XFile('assets/images/add_review.png'),
        XFile('assets/images/add_review.png'),
      ];
    });

    await tester.pumpWidget(
      createWidgetUnderTest(),
    );

    await tester.enterText(
        find.byType(PriceTextField).first, 'Test Restaurant');
    await tester.pump();

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    final submitButton = find.byType(SubmitButton);
    expect(tester.widget<SubmitButton>(submitButton).onClick, isNotNull);
  });

  testWidgets('Image picker updates selected images for menu images',
      (WidgetTester tester) async {
    when(mockImagePicker.pickMultiImage(imageQuality: 20))
        .thenAnswer((_) async {
      return [
        XFile('assets/images/add_review.png'),
        XFile('assets/images/add_review.png'),
      ];
    });
    await tester.pumpWidget(createWidgetUnderTest());

    when(mockCandidateBloc.state).thenReturn(CandidateLoading());
    await tester
        .tap(find.byKey(CandidateRestaurantPageWidgetKeys.menuImageSelectKey));
    await tester.pumpAndSettle();

    expect(find.text('Selected images'), findsOneWidget);
    expect(find.byType(SelectedImageDisplay), findsNWidgets(2));
  });

  testWidgets('Image picker updates selected images for restaurant images',
      (WidgetTester tester) async {
    when(mockImagePicker.pickMultiImage(imageQuality: 20))
        .thenAnswer((_) async {
      return [
        XFile('assets/images/add_review.png'),
        XFile('assets/images/add_review.png'),
      ];
    });
    await tester.pumpWidget(createWidgetUnderTest());

    when(mockCandidateBloc.state).thenReturn(CandidateLoading());
    await tester.tap(
        find.byKey(CandidateRestaurantPageWidgetKeys.restaurantImageSelectKey));

    await tester.pumpAndSettle();

    expect(find.text('Selected images'), findsOneWidget);
    expect(find.byType(SelectedImageDisplay), findsNWidgets(2));
  });

  testWidgets('shows loading button on loading state',
      (WidgetTester tester) async {
    when(mockCandidateBloc.state).thenReturn(CandidateLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(LoadingButton), findsOneWidget);
  });

  testWidgets('SnackBar is shown when no images are selected',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    when(mockImagePicker.pickMultiImage(imageQuality: 20))
        .thenAnswer((_) async {
      return [];
    });

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Nothing is selected'), findsOneWidget);
  });

  // testWidgets('BlocListener reacts to success state',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());

  //   when(mockCandidateBloc.state)
  //       .thenReturn(CandidateSuccess(message: 'Success!'));
  //   await tester.pumpAndSettle();

  //   // expect(find.text('Success!'),
  //   //     findsOneWidget);

  //   final finder = find.text('Success!');
  //   const Duration timeout = Duration(seconds: 3);
  //   final DateTime start = DateTime.now();
  //   while (DateTime.now().difference(start) < timeout) {
  //     if (tester.any(finder)) {
  //       break;
  //     }
  //     await tester.pump(const Duration(milliseconds: 1));
  //   }

  //   if (!tester.any(finder)) {
  //     fail("Toast not found");
  //   }
  // });

  // testWidgets('BlocListener reacts to failure state',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());

  //   // Simulate a failed candidate submission
  //   when(mockCandidateBloc.state).thenReturn(CandidateFailure(error: 'Error!'));
  //   await tester.pump(); // Rebuild after state change

  //   // Check for toast message or other UI changes
  //   expect(find.text('Error!'),
  //       findsOneWidget); // Adjust based on your toast implementation
  // });
}
