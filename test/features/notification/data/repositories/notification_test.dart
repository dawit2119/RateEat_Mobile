import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/notification/data/data_sources/notification.dart';
import 'package:rateeat_mobile/src/features/notification/data/repositories/notification.dart';

import 'data.dart';
import 'notification_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationsRemoteDataSource>()])
void main() {
  late NotificationsRepositoryImpl notificationsRepositoryImpl;
  late MockNotificationsRemoteDataSource mockNotificationsRemoteDataSource;

  setUp(() {
    mockNotificationsRemoteDataSource = MockNotificationsRemoteDataSource();
    notificationsRepositoryImpl = NotificationsRepositoryImpl(
      notificationRemoteDataSource: mockNotificationsRemoteDataSource,
    );
  });

  group("Notifications repository unit test(Success scenario)", () {
    const userId = "bae3434331";
    const notificationId = "3438483afa";
    test("Should return list of notifications", () async {
      //Arrange
      when(mockNotificationsRemoteDataSource.getUserNotifications(
        userId: userId,
        page: 1,
        limit: 10,
      )).thenAnswer(
        (_) async => dummyNotifications,
      );
      //Act
      final result = await notificationsRepositoryImpl.getNotifications(
        userId: userId,
        page: 1,
        limit: 10,
      );

      // Assert
      expect(
        result,
        Right(
          dummyNotifications,
        ),
      );
    });
    test("Should mark notification status as read", () async {
      //Arrange
      when(mockNotificationsRemoteDataSource.markNotificationAsRead(
        notificationId: notificationId,
      )).thenAnswer(
        (_) async => dummyNotifications[0],
      );
      //Act
      final result = await notificationsRepositoryImpl.markNotificationAsRead(
        notificationId: notificationId,
      );

      // Assert
      expect(
        result,
        Right(
          dummyNotifications[0],
        ),
      );
    });
    test("Should return unread notification count of a user", () async {
      //Arrange
      when(mockNotificationsRemoteDataSource.getUnreadNotificationsCount(
        userId: userId,
      )).thenAnswer(
        (_) async => 10,
      );
      //Act
      final result =
          await notificationsRepositoryImpl.getUnReadNotificationsCount(
        userId: userId,
      );

      // Assert
      expect(
        result,
        const Right(
          10,
        ),
      );
    });
  });

  group("Notifications repository unit test(Failure scenario)", () {
    const userId = "bae3434331";
    test("Should throw Server exception when the server fails", () async {
      //Arrange
      when(mockNotificationsRemoteDataSource.getUserNotifications(
        userId: userId,
        page: 1,
        limit: 10,
      )).thenThrow(ServerException(errorMessage: 'Server error'));
      //Act
      final result = await notificationsRepositoryImpl.getNotifications(
        userId: userId,
        page: 1,
        limit: 10,
      );

      // Assert
      expect(result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
    });
  });
}
