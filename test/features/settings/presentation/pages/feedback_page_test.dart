import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_event.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_state.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/feedback_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/widgets/feedback_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'feedback_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FeedbackBloc>()])
void main() {
  late MockFeedbackBloc mockFeedbackBloc;

  setUp(() {
    mockFeedbackBloc = MockFeedbackBloc();
    when(mockFeedbackBloc.stream)
        .thenAnswer((_) => const Stream.empty()); // Ensures the stream exists
    when(mockFeedbackBloc.state).thenReturn(FeedbackInitial());
  });

  tearDown(() {
    reset(mockFeedbackBloc);
  });

// Define a minimal GoRouter setup that includes the FeedbackPage route
  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/feedbackPage',
      routes: [
        GoRoute(
          path: '/feedbackPage',
          builder: (context, state) => const FeedbackPage(),
        ),
      ],
    );
  }

  Widget createTestWidget() {
    final router = createTestRouter();

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            SizeConfig().init(context);
            return BlocProvider<FeedbackBloc>(
              create: (context) => mockFeedbackBloc,
              child: child!,
            );
          },
        );
      },
    );
  }

  testWidgets('displays initial UI correctly', (WidgetTester tester) async {
    when(mockFeedbackBloc.state).thenReturn(FeedbackInitial());

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(FeedbackField), findsOneWidget);
    expect(find.byType(SubmitButton), findsOneWidget);
  });

  testWidgets('shows loading button when submitting',
      (WidgetTester tester) async {
    when(mockFeedbackBloc.state).thenReturn(FeedbackLoading());

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(LoadingButton), findsOneWidget);
  });

  testWidgets('displays success toast on successful feedback submission',
      (WidgetTester tester) async {
    // Simulate state transitions

    when(mockFeedbackBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockFeedbackBloc.state)
        .thenReturn(FeedbackSuccess(message: 'Success'));

    // Pump the widget
    await tester.pumpWidget(createTestWidget());
    // await tester.pump(Duration(seconds: 2)); // Initial render
    final scaffoldElement = tester.element(find.byType(Scaffold));
    debugPrint(scaffoldElement.toStringDeep());

    // Simulate submitting feedback
    mockFeedbackBloc.add(SubmitFeedbackEvent(comment: 'Great app!'));
    await tester.pumpAndSettle(); // Wait for state changes and animations
    await tester.pump(Duration(seconds: 2)); // Wait for SnackBar to appear
    // Verify the SnackBar appears
    expect(find.byKey(Key('customToast')), findsOneWidget);
    expect(find.text('Success'), findsOneWidget);
  });
  testWidgets('displays error toast on feedback failure',
      (WidgetTester tester) async {
    whenListen(
      mockFeedbackBloc,
      Stream.fromIterable([FeedbackFailure(error: 'Submission failed')]),
      initialState: FeedbackInitial(),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('Submission failed'), findsOneWidget);
  });
}
