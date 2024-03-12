import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/notification.dart';
import '../repositories/notification.dart';

class MarkNotificationReadStatusUseCase
    extends UseCase<NotificationEntity, String> {
  final NotificationsRepository notificationRepository;

  MarkNotificationReadStatusUseCase({
    required this.notificationRepository,
  });
  @override
  Future<Either<Failure, NotificationEntity>> call(String params) async {
    return await notificationRepository.markNotificationAsRead(
      notificationId: params,
    );
  }
}
