import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/notification/domain/use_cases/get_un_read_notifications_count_use_case.dart';

import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';

import 'un_read_notification_counter_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetUnreadNotificationsCountUseCase>()])
void main() {
  late MockGetUnreadNotificationsCountUseCase
      mockGetUnreadNotificationsCountUseCase;
  late UnreadNotificationsCounterBloc unreadNotificationsCounterBloc;

  setUp(() {
    mockGetUnreadNotificationsCountUseCase =
        MockGetUnreadNotificationsCountUseCase();
    unreadNotificationsCounterBloc = UnreadNotificationsCounterBloc(
      getUnReadNotificationsCountUseCase:
          mockGetUnreadNotificationsCountUseCase,
    );
  });

  group("Get Unread notifications count bloc unit test", () {
    const userId = "bae3434331";

    test('Initial state should be UnreadNotificationsCounterLoading()', () {
      expect(
        unreadNotificationsCounterBloc.state,
        UnreadNotificationsCounterLoading(),
      );
    });

    blocTest<UnreadNotificationsCounterBloc, UnreadNotificationsCounterState>(
      "Get unread Notifications count event should emit [UnreadNotificationsCounterFetched]",
      build: () {
        when(mockGetUnreadNotificationsCountUseCase(
          userId,
        )).thenAnswer(
          (_) async => const Right(
            10,
          ),
        );
        return unreadNotificationsCounterBloc;
      },
      act: (bloc) => bloc.add(GetUnreadNotificationsCount(
        userId: userId,
      )),
      expect: () => <UnreadNotificationsCounterState>[
        UnreadNotificationsCounterLoading(),
        UnreadNotificationsCounterFetched(
          count: 10,
        ),
      ],
    );
  });
}
