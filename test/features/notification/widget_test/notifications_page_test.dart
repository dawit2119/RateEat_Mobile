import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/pages/notifications_page.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/widgets/notification_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../data/repositories/data.dart';
import 'notifications_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NotificationsBloc>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<NotificationsMarkAsReadBloc>()
])
void main() {
  group('NotificationPage Tests', () {
    late MockNotificationsBloc mockNotificationsBloc;
    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late LocalUserModel testUser;
    Map<String, List<NotificationEntity>> groupedNotifications = {};
    late MockNotificationsMarkAsReadBloc mockNotificationsMarkAsReadBloc;

    setUp(() async {
      await dpLocator.reset();
      mockNotificationsBloc = MockNotificationsBloc();
      mockNotificationsMarkAsReadBloc = MockNotificationsMarkAsReadBloc();
      mockAuthenticationLocalSource = MockAuthenticationLocalSource();
      testUser = LocalUserModel(id: '1', email: 'test@example.com');
      when(mockAuthenticationLocalSource.getUserCredential()).thenAnswer(
        (_) => LocalUserModel(
          id: "1",
          token: "test_token",
        ),
      );

      dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource,
      );
      dpLocator.registerFactory<NotificationsBloc>(
        () => mockNotificationsBloc,
      );
      groupedNotifications = {};
      for (var notification in dummyNotifications) {
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(notification.createdAt);
        if (!groupedNotifications.containsKey(formattedDate)) {
          groupedNotifications[formattedDate] = [];
        }
        groupedNotifications[formattedDate]?.add(notification);
      }
      SizeConfig.blockSizeVertical = 8;
      SizeConfig.screenWidth = 1000;
      SizeConfig.screenHeight = 2000;
      HttpOverrides.global = null;
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    Widget makeTestableWidget() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<NotificationsBloc>(
            create: (_) => mockNotificationsBloc,
          ),
          BlocProvider<NotificationsPageCubit>(
            create: (_) => NotificationsPageCubit(),
          ),
          BlocProvider<NotificationsMarkAsReadBloc>(
            create: (_) => mockNotificationsMarkAsReadBloc,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ResponsiveSizer(builder: (context, orientation, screenType) {
            return NotificationPage(
              user: testUser,
            );
          }),
        ),
      );
    }

    testWidgets(
        'Should display loading animation when notifications are loading',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(NotificationsLoading());

      await tester.pumpWidget(makeTestableWidget());
      expect(find.byKey(const Key("NotificationsLoadingAnimationWidget")),
          findsOneWidget);
    });
    testWidgets(
        'Should display Info  when notifications are loaded and there are no notifications',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(
          const NotificationsLoaded(notifications: {}, hasReachedMax: false));

      await tester.pumpWidget(makeTestableWidget());
      expect(
        find.byKey(const Key("NoNewNotifications")),
        findsOneWidget,
      );
    });
    testWidgets(
        'Should display notification tiles when notifications are loaded',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(
        NotificationsLoaded(
          notifications: groupedNotifications,
          hasReachedMax: false,
        ),
      );

      await tester.pumpWidget(makeTestableWidget());
      expect(find.byType(NotificationTile), findsWidgets);
      await tester.pumpWidget(Placeholder());
      await tester.pump(Duration(seconds: 1));
    });

    testWidgets('Should display error message when notifications fail to load',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(
        const NotificationActionsFailed(message: 'Unable to get notifications'),
      );

      await tester.pumpWidget(makeTestableWidget());
      expect(find.byType(ErrorAndInfoDisplayWidget), findsOneWidget);
      await tester.pumpWidget(Placeholder());
      await tester.pump(Duration(seconds: 1));
    });

    testWidgets('Should handle scroll to load more notifications',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(NotificationsLoaded(
          notifications: groupedNotifications, hasReachedMax: false));

      await tester.pumpWidget(makeTestableWidget());
      final Finder scrollViewFinder =
          find.byKey(const Key('list_of_all_notifications'));

      await tester.drag(scrollViewFinder, const Offset(0, -500));
      // Simulate scrolling to the bottom
      await tester.pumpAndSettle();

      verify(
        mockNotificationsBloc.add(
          const GetUserNotifications(userId: "1", page: 2),
        ),
      ).called(1);
      await tester.pumpWidget(Placeholder());
      await tester.pump(Duration(seconds: 1));
    });

    testWidgets('Should refresh notifications on pull down',
        (WidgetTester tester) async {
      when(mockNotificationsBloc.state).thenReturn(NotificationsLoaded(
          notifications: groupedNotifications, hasReachedMax: false));

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle(); // Finish animations and timers

      expect(find.byType(RefreshIndicator), findsOneWidget);
      final Finder refreshIndicator = find.byType(RefreshIndicator);
      await tester.fling(refreshIndicator, const Offset(0, 300),
          1000.0); // Perform swipe to refresh action
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      verify(
        mockNotificationsBloc.add(
          any,
        ),
      ).called(greaterThanOrEqualTo(1));
      await tester.pumpWidget(Placeholder());
      await tester.pump(Duration(seconds: 1));
    });
  });
}
