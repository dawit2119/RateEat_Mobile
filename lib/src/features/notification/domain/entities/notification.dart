import 'package:equatable/equatable.dart';
import './reactor.dart';
import './item_review.dart';
import './target_order.dart';

enum NotificationType {
  favoriteItem,
  restaurantReview,
  itemReview,
  draftReviewReminder,
  incentive,
  order,
  follow,
  general,
}

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType notifiableType;
  final String message;
  final TargetReview? targetReview;
  final TargetOrder? targetOrder;
  final NotificationReactor reactor;
  final DateTime createdAt;
  final bool readStatus;

  const NotificationEntity({
    required this.id,
    required this.notifiableType,
    required this.message,
    required this.reactor,
    required this.createdAt,
    required this.readStatus,
    this.targetReview,
    this.targetOrder,
  });

  NotificationEntity copyWith({
    NotificationType? notifiableType,
    String? message,
    NotificationReactor? reactor,
    DateTime? createdAt,
    bool? readStatus,
    TargetReview? targetReview,
    TargetOrder? targetOrder,
  }) {
    return NotificationEntity(
      id: id,
      notifiableType: notifiableType ?? this.notifiableType,
      message: message ?? this.message,
      reactor: reactor ?? this.reactor,
      createdAt: createdAt ?? this.createdAt,
      readStatus: readStatus ?? this.readStatus,
      targetReview: targetReview ?? this.targetReview,
      targetOrder: targetOrder ?? this.targetOrder,
    );
  }

  @override
  List<Object?> get props => [
        id,
        notifiableType,
        message,
        reactor,
        createdAt,
        readStatus,
        targetReview,
        targetOrder,
      ];
}
