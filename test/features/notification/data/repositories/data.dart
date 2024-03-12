import 'package:rateeat_mobile/src/features/notification/data/models/item_review.dart';
import 'package:rateeat_mobile/src/features/notification/data/models/notification.dart';
import 'package:rateeat_mobile/src/features/notification/data/models/reactor.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';

List<NotificationModel> dummyNotifications = [
  NotificationModel(
    id: "1",
    notifiableType: NotificationType.favoriteItem,
    message: "Your favorite item is back in stock!",
    reactor: const NotificationReactorModel(
      firstName: "John",
      lastName: "Doe",
      profileImageUrl: "https://example.com/images/user1.jpg",
    ),
    createdAt: DateTime.now(),
    readStatus: false,
  ),
  NotificationModel(
    id: "2",
    notifiableType: NotificationType.restaurantReview,
    message: "A new review has been posted for your restaurant.",
    reactor: const NotificationReactorModel(
      firstName: "Emily",
      lastName: "Clark",
      profileImageUrl: "https://example.com/images/user2.jpg",
    ),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    readStatus: true,
    targetReview: TargetReviewModel(
      id: "101",
      notifiableId: "201",
      userId: "301",
      rating: 4.5,
      comment: "Great food, will come back again!",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: "https://example.com/images/user2.jpg",
    ),
  ),
  NotificationModel(
    id: "3",
    notifiableType: NotificationType.itemReview,
    message: "Your review has received a new like!",
    reactor: const NotificationReactorModel(
      firstName: "Alex",
      lastName: "Johnson",
      profileImageUrl: "https://example.com/images/user3.jpg",
    ),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    readStatus: false,
  ),
  NotificationModel(
    id: "4",
    notifiableType: NotificationType.draftReviewReminder,
    message: "You have a draft review waiting to be completed!",
    reactor: const NotificationReactorModel(
      firstName: "Sophia",
      lastName: "Brown",
      profileImageUrl: "https://example.com/images/user4.jpg",
    ),
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    readStatus: false,
  ),
  NotificationModel(
    id: "5",
    notifiableType: NotificationType.incentive,
    message: "You've earned a reward! Claim it now.",
    reactor: const NotificationReactorModel(
      firstName: "Michael",
      lastName: "Williams",
      profileImageUrl: "https://example.com/images/user5.jpg",
    ),
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    readStatus: true,
  )
];
