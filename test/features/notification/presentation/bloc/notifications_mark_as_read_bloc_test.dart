import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/mark_notification_read_status.dart';

import 'package:rateeat_mobile/src/features/notification/presentation/bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';

import '../../data/repositories/data.dart';
import 'notifications_mark_as_read_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MarkNotificationReadStatusUseCase>()])
void main() {
  late MockMarkNotificationReadStatusUseCase
      mockMarkNotificationReadStatusUseCase;
  late NotificationsMarkAsReadBloc notificationsMarkAsReadBloc;

  setUp(() {
    mockMarkNotificationReadStatusUseCase =
        MockMarkNotificationReadStatusUseCase();
    notificationsMarkAsReadBloc = NotificationsMarkAsReadBloc(
      markNotificationReadStatusUseCase: mockMarkNotificationReadStatusUseCase,
    );
  });

  group("Mark Notifications as read bloc unit test", () {
    const notificationId = "1";

    test('Initial state should be NotificationsInitial()', () {
      expect(
        notificationsMarkAsReadBloc.state,
        NotificationInitial(),
      );
    });

    blocTest<NotificationsMarkAsReadBloc, NotificationsMarkAsReadState>(
      "Fetch Notifications event should emit [NotificationsLoading(), NotificationsLoaded()]",
      build: () {
        when(mockMarkNotificationReadStatusUseCase(
          notificationId,
        )).thenAnswer(
          (_) async => Right(
            dummyNotifications[0],
          ),
        );
        return notificationsMarkAsReadBloc;
      },
      act: (bloc) => bloc.add(const MarkNotificationStatusAsRead(
        notificationId: notificationId,
      )),
      expect: () => <NotificationsMarkAsReadState>[
        MarkNotificationAsReadLoading(),
        const MarkNotificationAsReadSuccess(
            message: "Mark notification success"),
      ],
    );
  });
}
