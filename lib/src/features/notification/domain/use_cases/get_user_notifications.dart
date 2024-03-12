import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/notification.dart';
import '../repositories/notification.dart';

class GetUserNotificationsUseCase extends UseCase<List<NotificationEntity>,
    GetUserNotificationsUseCaseParams> {
  final NotificationsRepository notificationRepository;

  GetUserNotificationsUseCase({
    required this.notificationRepository,
  });
  @override
  Future<Either<Failure, List<NotificationEntity>>> call(params) async {
    return await notificationRepository.getNotifications(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetUserNotificationsUseCaseParams {
  final String userId;
  final int limit;
  final int page;

  GetUserNotificationsUseCaseParams({
    required this.userId,
    required this.limit,
    required this.page,
  });
}
