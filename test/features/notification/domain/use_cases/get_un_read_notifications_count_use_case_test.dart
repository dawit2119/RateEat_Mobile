import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/notification/domain/repositories/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/get_un_read_notifications_count_use_case.dart';

import 'get_un_read_notifications_count_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationsRepository>()])
void main() {
  late GetUnreadNotificationsCountUseCase getUnreadNotificationsCountUseCase;
  late MockNotificationsRepository mockNotificationsRepository;

  setUp(() {
    mockNotificationsRepository = MockNotificationsRepository();
    getUnreadNotificationsCountUseCase = GetUnreadNotificationsCountUseCase(
      notificationRepository: mockNotificationsRepository,
    );
  });

  test("Should return list of notifications", () async {
    const userId = "bae3434331";

    when(mockNotificationsRepository.getUnReadNotificationsCount(
      userId: userId,
    )).thenAnswer(
      (_) async => const Right(
        10,
      ),
    );
    final result = await getUnreadNotificationsCountUseCase(
      userId,
    );
    expect(
      result,
      const Right(
        10,
      ),
    );
    verify(mockNotificationsRepository.getUnReadNotificationsCount(
      userId: userId,
    ));
    verifyNoMoreInteractions(mockNotificationsRepository);
  });
}
