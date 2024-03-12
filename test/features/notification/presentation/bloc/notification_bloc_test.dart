import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/get_user_notifications.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';

import '../../data/repositories/data.dart';
import 'notification_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetUserNotificationsUseCase>()])
void main() {
  late MockGetUserNotificationsUseCase mockGetUserNotificationsUseCase;
  late NotificationsBloc notificationsBloc;

  setUp(() {
    mockGetUserNotificationsUseCase = MockGetUserNotificationsUseCase();
    notificationsBloc = NotificationsBloc(
      getUserNotificationsUseCase: mockGetUserNotificationsUseCase,
    );
  });

  group("Fetch user notifications bloc unit test", () {
    const userId = "bae3434331";
    const notificationId = "1";
    Map<String, List<NotificationEntity>> groupedNotifications = {};
    for (var notification in dummyNotifications) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(notification.createdAt);
      if (!groupedNotifications.containsKey(formattedDate)) {
        groupedNotifications[formattedDate] = [];
      }
      groupedNotifications[formattedDate]?.add(notification);
    }
    test('Initial state should be NotificationsInitial()', () {
      expect(
        notificationsBloc.state,
        NotificationInitial(),
      );
    });

    blocTest<NotificationsBloc, NotificationsState>(
      "Fetch Notifications event should emit [NotificationsLoading(), NotificationsLoaded()]",
      build: () {
        when(mockGetUserNotificationsUseCase(
          any,
          // GetUserNotificationsUseCaseParams(userId: userId, limit: 10, page: 1),
        )).thenAnswer(
          (_) async => Right(
            dummyNotifications,
          ),
        );
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(const GetUserNotifications(
        userId: userId,
        page: 1,
      )),
      expect: () => <NotificationsState>[
        NotificationsLoading(),
        NotificationsLoaded(
          notifications: groupedNotifications,
        ),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      "Should flip notifications status locally and  emit [NotificationsLoading(), NotificationsLoaded()]",
      build: () {
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(
        UpdateNotificationReadStatusLocally(
          key: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          notificationId: notificationId,
          notifications: groupedNotifications,
        ),
      ),
      expect: () => <NotificationsState>[
        NotificationsLoading(),
        NotificationsLoaded(
          notifications: groupedNotifications,
        ),
      ],
    );
  });
}
