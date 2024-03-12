import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/notification/data/data_sources/notification.dart';
import 'package:rateeat_mobile/src/features/notification/data/models/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';

import 'notification_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
Future<void> main() async {
  late NotificationsRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthSource;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() async {
    mockDio = MockDio();
    mockAuthSource = MockAuthenticationLocalSource();
    dataSource = NotificationsRemoteDataSourceImpl(dio: mockDio);
    await dpLocator.reset();
    dpLocator
        .registerLazySingleton<AuthenticationLocalSource>(() => mockAuthSource);
  });

  group('NotificationsRemoteDataSourceImpl', () {
    const userId = 'user123';
    const notificationId = 'notif123';

    test('getUserNotifications returns a list of NotificationModel', () async {
      // Arrange
      final mockResponse = {
        "data": [
          {"id": notificationId, "message": "New message"},
        ]
      };

      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'token123'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: mockResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.getUserNotifications(
          userId: userId, page: 1, limit: 10);

      // Assert
      expect(result, isA<List<NotificationModel>>());
      expect(result.length, 1);
      expect(result.first.id, notificationId);
    });

    test('getUserNotifications throws Exception if user is not authenticated',
        () async {
      // Arrange
      when(mockAuthSource.getUserCredential()).thenReturn(null);

      // Act & Assert
      expect(
          () async => await dataSource.getUserNotifications(
              userId: userId, page: 1, limit: 10),
          throwsA(isA<Exception>()));
    });

    test('getUserNotifications throws ServerException on non-200 response',
        () async {
      // Arrange
      when(mockAuthSource.getUserCredential())
          .thenReturn(LocalUserModel(token: 'token123'));
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
          (_) async => Response(
              data: {},
              statusCode: 500,
              requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(
          () async => await dataSource.getUserNotifications(
              userId: userId, page: 1, limit: 10),
          throwsA(isA<ServerException>()));
    });

    test(
        'markNotificationAsRead marks notification and returns updated NotificationEntity',
        () async {
      // Arrange
      final mockResponse = {
        "data": {"id": notificationId, "message": "Notification marked read"}
      };

      when(mockDio.put(any)).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.markNotificationAsRead(
          notificationId: notificationId);

      // Assert
      expect(result, isA<NotificationEntity>());
      expect(result.id, notificationId);
    });

    test('markNotificationAsRead throws Exception on error', () async {
      // Arrange
      when(mockDio.put(any)).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError));

      // Act & Assert
      expect(
          () async => await dataSource.markNotificationAsRead(
              notificationId: notificationId),
          throwsA(isA<Exception>()));
    });

    test('getUnreadNotificationsCount returns unread count', () async {
      // Arrange
      final mockResponse = {"unreadNotificationsCount": 5};

      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      // Act
      final result =
          await dataSource.getUnreadNotificationsCount(userId: userId);

      // Assert
      expect(result, 5);
    });

    test(
        'getUnreadNotificationsCount throws ServerException on non-200 response',
        () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: {}, statusCode: 500, requestOptions: RequestOptions(path: '')));

      // Act & Assert
      expect(
          () async =>
              await dataSource.getUnreadNotificationsCount(userId: userId),
          throwsA(isA<ServerException>()));
    });
  });
}
