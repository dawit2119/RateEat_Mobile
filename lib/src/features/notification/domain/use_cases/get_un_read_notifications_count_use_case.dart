import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../repositories/notification.dart';

class GetUnreadNotificationsCountUseCase extends UseCase<int, String> {
  final NotificationsRepository notificationRepository;

  GetUnreadNotificationsCountUseCase({
    required this.notificationRepository,
  });

  @override
  Future<Either<Failure, int>> call(String params) async {
    return await notificationRepository.getUnReadNotificationsCount(
      userId: params,
    );
  }
}
