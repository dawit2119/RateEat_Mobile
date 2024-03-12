import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/get_user_notifications.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../data/repositories/data.dart';
import 'get_un_read_notifications_count_use_case_test.mocks.dart';

void main() {
  late GetUserNotificationsUseCase getUserNotificationsUseCase;
  late MockNotificationsRepository mockNotificationsRepository;

  setUp(() {
    mockNotificationsRepository = MockNotificationsRepository();
    getUserNotificationsUseCase = GetUserNotificationsUseCase(
      notificationRepository: mockNotificationsRepository,
    );
  });

  test("Should return list of notifications", () async {
    const userId = "bae3434331";

    when(mockNotificationsRepository.getNotifications(
      userId: userId,
      page: 1,
      limit: 10,
    )).thenAnswer(
      (_) async => Right(
        dummyNotifications,
      ),
    );
    final result = await getUserNotificationsUseCase(
      GetUserNotificationsUseCaseParams(
        userId: userId,
        limit: 10,
        page: 1,
      ),
    );
    expect(
      result,
      Right(
        dummyNotifications,
      ),
    );
    verify(mockNotificationsRepository.getNotifications(
      userId: userId,
      limit: 10,
      page: 1,
    ));
    verifyNoMoreInteractions(mockNotificationsRepository);
  });
}
