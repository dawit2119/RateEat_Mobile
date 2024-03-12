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

import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_response_model.dart'
    as monthly_model;
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart'
    as rank;
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_response_model.dart'
    as weekly_model;

import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';

import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/monthly_leader_board/monthly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_state.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/weekly_leader_board/weekly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/pages/leaderboard.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/widgets/leader_card.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/widgets/leader_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'leaderboard_widget_test.mocks.dart';

class MockRankBloc extends Mock implements RankBloc {}

class MockLeaderBoardBloc extends Mock implements LeaderBoardBloc {}

class MockLocalAnalyticsObserver extends Mock
    implements LocalAnalyticsObserver {}

class MockAnalyticsObserver extends Mock implements AnalyticsObserver {}

class MockAuthenticationLocalSource extends Mock
    implements AuthenticationLocalSource {}

class MockMonthlyLeaderBoardBloc extends Mock
    implements MonthlyLeaderBoardBloc {}

class MockAllTimePageCubit extends Mock
    implements AllTimeLeaderBoardPageCubit {}

class MockWeeklyPageCubit extends Mock implements WeeklyLeaderBoardPageCubit {}

class MockMonthlyPageCubit extends Mock
    implements MonthlyLeaderBoardPageCubit {}

class MockWeeklyLeaderBoardBloc extends Mock implements WeeklyLeaderBoardBloc {}

@GenerateNiceMocks([
  MockSpec<MockRankBloc>(),
  MockSpec<MockWeeklyPageCubit>(),
  MockSpec<MockMonthlyPageCubit>(),
  MockSpec<MockAllTimePageCubit>(),
  MockSpec<MockLeaderBoardBloc>(),
  MockSpec<MockAuthenticationLocalSource>(),
  MockSpec<MockLocalAnalyticsObserver>(),
  MockSpec<MockAnalyticsObserver>(),
  MockSpec<MockWeeklyLeaderBoardBloc>(),
  MockSpec<MockMonthlyLeaderBoardBloc>(),
])
void main() {
  group('Leadear board Widget Test', () {
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockLeaderBoardBloc mockLeaderBoardBloc;
    late MockWeeklyLeaderBoardBloc mockWeeklyLeaderBoardBloc;
    late MockMonthlyLeaderBoardBloc mockMonthlyLeaderBoardBloc;
    // late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late MockAllTimePageCubit mockAllTimePageCubit;
    late MockMonthlyPageCubit mockMonthlyPageCubit;
    late MockWeeklyPageCubit mockWeeklyPageCubit;
    late MockRankBloc mockRankBloc;
    setUp(() {
      mockLocalAnalyticsObserver = MockLocalAnalyticsObserver();
      mockAnalyticsObserver = MockAnalyticsObserver();
      mockLeaderBoardBloc = MockMockLeaderBoardBloc();
      mockMonthlyLeaderBoardBloc = MockMockMonthlyLeaderBoardBloc();
      mockWeeklyLeaderBoardBloc = MockMockWeeklyLeaderBoardBloc();
      // mockAuthenticationLocalSource = MockMockAuthenticationLocalSource();
      mockAllTimePageCubit = MockMockAllTimePageCubit();
      mockMonthlyPageCubit = MockMockMonthlyPageCubit();
      mockWeeklyPageCubit = MockMockWeeklyPageCubit();
      mockRankBloc = MockMockRankBloc();

      dpLocator.registerLazySingleton<RankBloc>(() => mockRankBloc);
      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
          () => MockMockAuthenticationLocalSource());
      dpLocator.registerFactory<LeaderBoardBloc>(() => mockLeaderBoardBloc);
      dpLocator.registerFactory<MonthlyLeaderBoardBloc>(
          () => mockMonthlyLeaderBoardBloc);
      dpLocator.registerFactory<WeeklyLeaderBoardBloc>(
          () => mockWeeklyLeaderBoardBloc);
      dpLocator.registerFactory<AllTimeLeaderBoardPageCubit>(
          () => mockAllTimePageCubit);
      dpLocator.registerFactory<MonthlyLeaderBoardPageCubit>(
          () => mockMonthlyPageCubit);

      dpLocator.registerFactory<WeeklyLeaderBoardPageCubit>(
          () => mockWeeklyPageCubit);

      dpLocator.registerFactory<LocalAnalyticsObserver>(
        () => mockLocalAnalyticsObserver,
      );
      dpLocator.registerFactory<AnalyticsObserver>(
        () => mockAnalyticsObserver,
      );

      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MaterialApp(
        home: Builder(builder: (context) {
          SizeConfig().init(context);
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => dpLocator<RankBloc>(),
              ),
              BlocProvider(
                  create: (context) => dpLocator<WeeklyLeaderBoardBloc>()),
              BlocProvider(
                  create: (context) => dpLocator<MonthlyLeaderBoardBloc>()),
              BlocProvider(
                create: (context) => dpLocator<LeaderBoardBloc>(),
              ),
              BlocProvider(
                  create: (context) =>
                      dpLocator<AllTimeLeaderBoardPageCubit>()),
              BlocProvider(
                  create: (context) =>
                      dpLocator<MonthlyLeaderBoardPageCubit>()),
              BlocProvider(
                  create: (context) => dpLocator<WeeklyLeaderBoardPageCubit>()),
            ],
            child: MaterialApp(
              locale: const Locale('en', 'US'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home:
                  ResponsiveSizer(builder: (context, orientation, screenType) {
                return body;
              }),
            ),
          );
        }),
      );
    }

    testWidgets(
        'Should display loading state when rank bloc is in loading state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => const Stream.empty());

      // file the cte
      when(mockRankBloc.state).thenAnswer((_) => RankLoading());
      // when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
      //     rank: rank.Rank(
      //         rank: 1,
      //         id: '1',
      //         userId: '1',
      //         allTimeTotal: 10,
      //         currentTotal: 10,
      //         createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      //         updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
      //         user: rank.User(
      //             id: '1',
      //             firstName: 'name',
      //             lastName: 'name',
      //             email: 'email',
      //             phoneNumber: 'phone',
      //             image: 'image'))));

      // when(mockLeaderBoardBloc.state).thenAnswer((_) => LeaderBoardLoading());
      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();
      expect(find.text('Loading ranks'), findsOneWidget);
    });

    testWidgets('Should display success when rank bloc is in success state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();

      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('Should display error when rank bloc is in error state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => const Stream.empty());
      when(mockRankBloc.state)
          .thenAnswer((_) => RankError(error: 'Failed to load ranks'));

      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();

      expect(find.text('Failed to load ranks'), findsOneWidget);
      expect(find.text('retry'), findsOneWidget);
    });

//weekly
    testWidgets(
        'Should display sucess when in weekly time leader board is success',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockWeeklyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockWeeklyLeaderBoardBloc.state)
          .thenAnswer((_) => WeeklyLeaderBoardLoaded(
                  standings: WeeklyLeaderBoardResponses(users: [
                weekly_model.WeeklyLeaderBoardResponse(
                    user: weekly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200),
                weekly_model.WeeklyLeaderBoardResponse(
                    user: weekly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200),
                weekly_model.WeeklyLeaderBoardResponse(
                    user: weekly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200)
              ], rank: 0)));
      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      debugPrint(tester.widgetList(find.byType(Widget)).toString());
      expect(find.byType(LeaderWidget), findsWidgets);
    });

    testWidgets(
        'Should display error when in weekly time leader board is in error state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockWeeklyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockWeeklyLeaderBoardBloc.state)
          .thenAnswer((_) => WeeklyLeaderBoardFailure(message: 'message'));

      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();

      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
        'Should display loading when in weekly time leader board is loading state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockWeeklyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockWeeklyLeaderBoardBloc.state)
          .thenAnswer((_) => WeeklyLeaderBoardLoading());

      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    //monthly tab
    testWidgets(
        'Should display loading when in monthly leader board is loading state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockMonthlyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockMonthlyLeaderBoardBloc.state)
          .thenAnswer((_) => MonthlyLeaderBoardLoading());
      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets(
        'Should display empty message widget when in monthly leader board is success but empty state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockMonthlyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockMonthlyLeaderBoardBloc.state).thenAnswer((_) =>
          MonthlyLeaderBoardLoaded(
              standings: MonthlyLeaderBoardResponses(users: [], rank: 0)));
      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();
      await tester.pumpAndSettle();

      final monthlyTabFinder =
          find.text('Monthly'); // Adjust if localization is used

      // Verify that the Monthly tab is present
      expect(monthlyTabFinder, findsOneWidget);
      await tester.tap(monthlyTabFinder);

      // Allow the widget to rebuild
      await tester.pumpAndSettle();

      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });

    testWidgets(
      'Should display the results when the monthly leaderboard is successful with items state',
      (WidgetTester tester) async {
        // Mock the RankBloc state
        when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
        when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
            rank: rank.Rank(
                rank: 1,
                id: '1',
                userId: '1',
                allTimeTotal: 10,
                currentTotal: 10,
                createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
                updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
                user: rank.User(
                    id: '1',
                    firstName: 'John',
                    lastName: 'Doe',
                    email: 'john@example.com',
                    phoneNumber: '1234567890',
                    image: 'https://example.com/image.png'))));

        // Mock the MonthlyLeaderBoardBloc state with valid data
        when(mockMonthlyLeaderBoardBloc.stream)
            .thenAnswer((_) => const Stream.empty());

        when(mockMonthlyLeaderBoardBloc.state)
            .thenAnswer((_) => MonthlyLeaderBoardLoaded(
                    standings: MonthlyLeaderBoardResponses(users: [
                  monthly_model.MonthlyLeaderBoardResponse(
                      user: monthly_model.User(
                          id: '1',
                          firstName: 'John',
                          lastName: 'Doe',
                          email: 'john@example.com',
                          image: 'https://example.com/image.png',
                          streak: 20,
                          phoneNumber: '1234567890'),
                      totalPoints: 200),
                  monthly_model.MonthlyLeaderBoardResponse(
                      user: monthly_model.User(
                          id: '2',
                          firstName: 'Jane',
                          lastName: 'Smith',
                          email: 'jane@example.com',
                          image: 'https://example.com/image2.png',
                          streak: 15,
                          phoneNumber: '0987654321'),
                      totalPoints: 150),
                  monthly_model.MonthlyLeaderBoardResponse(
                      user: monthly_model.User(
                          id: '3',
                          firstName: 'Bob',
                          lastName: 'Johnson',
                          email: 'bob@example.com',
                          image: 'https://example.com/image3.png',
                          streak: 10,
                          phoneNumber: '1122334455'),
                      totalPoints: 100),
                ], rank: 1)));

        await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
        await tester.pump();

        // Increase timeout for pumpAndSettle
        await tester.pumpAndSettle(Duration(seconds: 150));

        final monthlyTabFinder =
            find.text('Monthly'); // Adjust if localization is used

        // Verify that the Monthly tab is present
        expect(monthlyTabFinder, findsOneWidget);
        await tester.tap(monthlyTabFinder);
        await tester.pump();

        // Allow the widget to rebuild
        await tester.pumpAndSettle(Duration(seconds: 150));

        // Verify that the LeaderCard is displayed
        expect(find.byType(LeaderCard),
            findsNWidgets(3)); // Adjust based on the number of users you expect
      },
    );

    testWidgets(
        'Should display error widget when in monthly leader board is Error state',
        (WidgetTester tester) async {
      when(mockRankBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockRankBloc.state).thenAnswer((_) => RankSuccess(
          rank: rank.Rank(
              rank: 1,
              id: '1',
              userId: '1',
              allTimeTotal: 10,
              currentTotal: 10,
              createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
              updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
              user: rank.User(
                  id: '1',
                  firstName: 'name',
                  lastName: 'name',
                  email: 'email',
                  phoneNumber: 'phone',
                  image: 'image'))));
      when(mockMonthlyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockMonthlyLeaderBoardBloc.state)
          .thenAnswer((_) => MonthlyLeaderBoardLoaded(
                  standings: MonthlyLeaderBoardResponses(users: [
                monthly_model.MonthlyLeaderBoardResponse(
                    user: monthly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200),
                monthly_model.MonthlyLeaderBoardResponse(
                    user: monthly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200),
                monthly_model.MonthlyLeaderBoardResponse(
                    user: monthly_model.User(
                        id: '',
                        firstName: '',
                        lastName: '',
                        email: '',
                        image: '',
                        streak: 20,
                        phoneNumber: ''),
                    totalPoints: 200)
              ], rank: 0)));
      when(mockMonthlyLeaderBoardBloc.stream)
          .thenAnswer((_) => const Stream.empty());
      when(mockMonthlyLeaderBoardBloc.state)
          .thenAnswer((_) => MonthlyLeaderBoardFailure(message: ''));

      await tester.pumpWidget(makeTestableWidget(const LeaderBoard()));
      await tester.pump();
      await tester.pumpAndSettle();

      final monthlyTabFinder =
          find.text('Monthly'); // Adjust if localization is used

      // Verify that the Monthly tab is present
      expect(monthlyTabFinder, findsOneWidget);
      await tester.tap(monthlyTabFinder);
      await tester.pumpAndSettle();

      // Allow the widget to rebuild

      // Verify the presence of SingleChildScrollView
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
    });
  });
}
