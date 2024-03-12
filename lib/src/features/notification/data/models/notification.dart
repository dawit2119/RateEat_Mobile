import 'package:rateeat_mobile/src/features/notification/data/models/target_order_impl.dart';

import './item_review.dart';
import '../../domain/entities/notification.dart';
import './reactor.dart';

NotificationType parseNotificationType(String typeString) {
  switch (typeString) {
    case 'FavoriteItem':
      return NotificationType.favoriteItem;
    case 'RestaurantReview':
      return NotificationType.restaurantReview;
    case 'ItemReview':
      return NotificationType.itemReview;
    case 'DraftReviewReminder':
      return NotificationType.draftReviewReminder;
    case 'Incentive':
      return NotificationType.incentive;
    case 'Order':
      return NotificationType.order;
    case 'Follow':
      return NotificationType.follow;
    default:
      return NotificationType.general;
  }
}

class NotificationModel extends NotificationEntity {
  const NotificationModel(
      {required super.id,
      required super.notifiableType,
      required super.message,
      required super.reactor,
      required super.createdAt,
      required super.readStatus,
      super.targetReview,
      super.targetOrder});

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      notifiableType: json['notification_category'] == "Reward"
          ? parseNotificationType('Incentive')
          : parseNotificationType(json['notifiable_type'] ?? ""),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      readStatus: json['read_status'] ?? false,
      message: json['message'] ?? '',
      targetReview: json["item_review"] != null
          ? json['item_review'] != null
              ? TargetReviewModel.fromMap(json['item_review'])
              : null
          : json['notifiableReview'] != null
              ? TargetReviewModel.fromMap(json['notifiableReview'])
              : null,
      targetOrder: json["notifiable_type"] == "Order"
          ? TargetOrderImpl(
              id: json["notifiable_id"],
              restaurantId: json["orderRestaurantId"])
          : null,
      reactor: NotificationReactorModel.fromMap(
        json['reactor'] ?? <String, dynamic>{},
      ),
    );
  }
}
