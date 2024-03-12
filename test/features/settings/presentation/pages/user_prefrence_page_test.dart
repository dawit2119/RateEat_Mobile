import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_preference.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'user_prefrence_page_test.mocks.dart';

class FakeGoRouterDelegate extends Fake implements GoRouterDelegate {}

class FakeRouteInformationParser extends Fake
    implements RouteInformationParser {}

class FakeRouteInformationProvider extends Fake
    implements RouteInformationProvider {}

// Generate mocks
@GenerateNiceMocks([
  MockSpec<UserPreferenceBloc>(),
  MockSpec<GoRouter>(),
])
void main() {
  late MockUserPreferenceBloc mockBloc;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockBloc = MockUserPreferenceBloc();
    mockGoRouter = MockGoRouter();

    when(mockGoRouter.routerDelegate).thenReturn(FakeGoRouterDelegate());
  });

  Widget createTestWidget() {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        SizeConfig().init(context); // Initialize size configuration

        return BlocProvider<UserPreferenceBloc>(
          create: (_) => mockBloc,
          child: MaterialApp.router(
            routerDelegate: mockGoRouter.routerDelegate,
            routeInformationParser: mockGoRouter.routeInformationParser,
            routeInformationProvider: mockGoRouter.routeInformationProvider,
            builder: (context, child) => child!,
          ),
        );
      },
    );
  }

  testWidgets('renders UserPreferencesPage correctly',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(PreviousPreferencesFetched(
      userPreference:
          UserPreference(walkingDistance: 500, minNumberOfReviews: 10),
    ));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("Preferences"), findsOneWidget);
    expect(find.text("Preferred walking distance (meters)"), findsOneWidget);
    expect(find.text("Preferred Minimum number of reviews"), findsOneWidget);
  });

  testWidgets('loads previous preferences into text fields',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(PreviousPreferencesFetched(
      userPreference:
          UserPreference(walkingDistance: 1000, minNumberOfReviews: 20),
    ));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("1000"), findsOneWidget);
    expect(find.text("20"), findsOneWidget);
  });

  testWidgets('displays error toast when invalid input is given',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(UserPreferenceInitial());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final distanceField = find.byType(TextField).first;
    final reviewField = find.byType(TextField).last;
    final submitButton = find.textContaining("Update"); // Ensure correct button

    await tester.enterText(distanceField, "-50");
    await tester.enterText(reviewField, "abc");
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text("only use numeric values"), findsOneWidget);
  });

  testWidgets('calls update preference when valid input is provided',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(UserPreferenceInitial());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final distanceField = find.byType(TextField).first;
    final reviewField = find.byType(TextField).last;
    final submitButton = find.textContaining("Update");

    await tester.enterText(distanceField, "600");
    await tester.enterText(reviewField, "15");
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    verify(() => mockBloc.add(UpdateUserPreference(
          preferredWalkingDistance: 600,
          preferredDrivingDistance: null,
          minNumberOfReviews: 15,
        ))).called(1);
  });

  testWidgets('shows loading animation when updating preferences',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(UserPreferenceUpdateLoading());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("Loading Animation Widget")), findsOneWidget);
  });

  testWidgets('shows success toast and navigates back when update succeeds',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(UserPreferenceUpdateSuccess());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("preference updated successfully"), findsOneWidget);
    verify(() => mockGoRouter.pop()).called(1);
  });

  testWidgets('shows error toast when update fails',
      (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(UserPreferenceUpdateFailed());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text("Retry"), findsOneWidget);
  });
}
