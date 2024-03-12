import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/mark_notification_read_status.dart';

import '../../data/repositories/data.dart';
import 'get_un_read_notifications_count_use_case_test.mocks.dart';

void main() {
  late MarkNotificationReadStatusUseCase markNotificationReadStatusUseCase;
  late MockNotificationsRepository mockNotificationsRepository;

  setUp(() {
    mockNotificationsRepository = MockNotificationsRepository();
    markNotificationReadStatusUseCase = MarkNotificationReadStatusUseCase(
      notificationRepository: mockNotificationsRepository,
    );
  });

  test("Should mark notification status as read", () async {
    const notificationId = "bae3434331";

    when(mockNotificationsRepository.markNotificationAsRead(
      notificationId: notificationId,
    )).thenAnswer(
      (_) async => Right(
        dummyNotifications[0],
      ),
    );
    final result = await markNotificationReadStatusUseCase(notificationId);
    expect(
      result,
      Right(
        dummyNotifications[0],
      ),
    );
    verify(mockNotificationsRepository.markNotificationAsRead(
      notificationId: notificationId,
    ));
    verifyNoMoreInteractions(mockNotificationsRepository);
  });
}
