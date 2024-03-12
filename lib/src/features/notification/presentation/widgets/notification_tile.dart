import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rateeat_mobile/src/core/utils/date_parser.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_persistent_bottom_navbar.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../item_detail/item_detail.dart';
import '../../domain/entities/notification.dart';
import '../bloc/fetch_notifications/notification_bloc.dart';

class NotificationTile extends StatelessWidget {
  final String createdAt;
  final List<NotificationEntity> notifications;

  const NotificationTile({
    super.key,
    required this.notifications,
    required this.createdAt,
  });

  String getDisplayTime(DateTime createdAt, context) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localCreatedAt = createdAt.toLocal();

    if (!localCreatedAt.difference(justNow).isNegative) {
      return AppLocalizations.of(context)!.nowText;
    }

    String roughTime;

    if (localCreatedAt.day == now.day &&
        localCreatedAt.month == now.month &&
        localCreatedAt.year == now.year) {
      Duration difference = now.difference(localCreatedAt);

      if (difference.inHours < 1) {
        roughTime =
            '${AppLocalizations.of(context)!.vocativeText}${difference.inMinutes} ${AppLocalizations.of(context)!.minutesAgo}';
      } else {
        roughTime =
            '${AppLocalizations.of(context)!.vocativeText}${difference.inHours} ${AppLocalizations.of(context)!.hourAgo}';
      }
    } else {
      roughTime = DateFormat('hh:mm a').format(localCreatedAt);
    }

    return roughTime;
  }

  String getDisplayDate(context) {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    var createdDay = DateTime.parse(createdAt);
    int differenceInDays = startOfToday.difference(createdDay).inDays;

    if (differenceInDays == 0) {
      return AppLocalizations.of(context)!.todayText;
    } else if (differenceInDays == 1) {
      return AppLocalizations.of(context)!.yesterdayText;
    } else {
      return createdAt;
    }
  }

  String getNotificationTitle(NotificationEntity notification, context) {
    var reactorFName = notification.reactor.firstName;
    if (notification.notifiableType == NotificationType.favoriteItem) {
      return "$reactorFName ${AppLocalizations.of(context)!.favoriteItemCommentMessage}";
    }
    if (notification.notifiableType == NotificationType.draftReviewReminder) {
      return AppLocalizations.of(context)!.draftText;
    }
    if (notification.notifiableType == NotificationType.incentive) {
      return AppLocalizations.of(context)!.incentivizeText;
    }
    if (notification.notifiableType == NotificationType.follow) {
      return "New follower";
    }
    if (notification.notifiableType == NotificationType.order) {
      return "Order status";
    }
    if (notification.notifiableType == NotificationType.itemReview ||
        notification.notifiableType == NotificationType.restaurantReview) {
      if (notification.message.contains('upvote')) {
        return "Upvote on review";
      } else if (notification.message.contains('downvote')) {
        return "Downvote on review";
      } else {
        return "Reaction on review";
      }
    }
    return "General notification";
  }

  String getNotificationSubTitle(NotificationEntity notification, context) {
    var reactorFName = notification.reactor.firstName;
    if (notification.notifiableType == NotificationType.favoriteItem) {
      if (notification.targetReview == null) {
        return "";
      }
      return "\"${notification.targetReview!.comment}\"";
    }
    if (notification.notifiableType == NotificationType.draftReviewReminder) {
      return AppLocalizations.of(context)!.draftReviewText;
    }
    if (notification.notifiableType == NotificationType.incentive) {
      return notification.message;
    }
    if (notification.notifiableType == NotificationType.follow) {
      return "$reactorFName started following you";
    }
    if (notification.notifiableType == NotificationType.order) {
      return notification.message;
    }
    if (notification.notifiableType == NotificationType.itemReview ||
        notification.notifiableType == NotificationType.restaurantReview) {
      return "$reactorFName ${AppLocalizations.of(context)!.reactionMessageSubTitleText}";
    }
    return notification.message;
  }

  /// ✅ Different icons per notification type
  Widget getNotificationIcon(NotificationEntity notification) {
    switch (notification.notifiableType) {
      case NotificationType.favoriteItem:
        return _buildIcon(Iconsax.star_1, Colors.white);
      case NotificationType.draftReviewReminder:
        return _buildIcon(Iconsax.note, Colors.white);
      case NotificationType.incentive:
        return _buildIcon(Iconsax.gift, Colors.white);
      case NotificationType.follow:
        return _buildIcon(Iconsax.user_add, Colors.white);
      case NotificationType.order:
        return _buildIcon(Iconsax.shopping_bag, Colors.white);
      case NotificationType.itemReview:
      case NotificationType.restaurantReview:
        if (notification.targetReview?.imageUrl != null) {
          return CircleAvatar(
            foregroundImage: NetworkImage(notification.targetReview!.imageUrl!),
          );
        }
        return _buildIcon(Iconsax.star_1, Colors.white);
      default:
        return _buildIcon(Iconsax.notification, Colors.white);
    }
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.notificationBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  /// ✅ Define which notifications are clickable
  bool isNotificationClickable(NotificationEntity notification) {
    return [
      NotificationType.favoriteItem,
      NotificationType.restaurantReview,
      NotificationType.itemReview,
      NotificationType.draftReviewReminder,
      NotificationType.order,
    ].contains(notification.notifiableType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formatDateTime(DateTime.parse(createdAt)),
              style: GoogleFonts.poppins(
                color: const Color(0xff35364F),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: notifications
                .map(
                  (notification) => VisibilityDetector(
                    key: Key(notification.id),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction == 1 &&
                          !notification.readStatus) {
                        context.read<NotificationsMarkAsReadBloc>().add(
                            MarkNotificationStatusAsRead(
                                notificationId: notification.id));
                      }
                    },
                    child: GestureDetector(
                      onTap: isNotificationClickable(notification)
                          ? () {
                              final notificationsBloc =
                                  context.read<NotificationsBloc>();
                              final setNoficationReadBloc =
                                  context.read<NotificationsMarkAsReadBloc>();
                              final state = notificationsBloc.state;
                              if (state is NotificationsLoaded) {
                                notificationsBloc.add(
                                  UpdateNotificationReadStatusLocally(
                                    key: createdAt,
                                    notificationId: notification.id,
                                    notifications: state.notifications,
                                  ),
                                );
                                setNoficationReadBloc.add(
                                    MarkNotificationStatusAsRead(
                                        notificationId: notification.id));
                              }

                              /// Navigation per notification type
                              if (notification.notifiableType ==
                                  NotificationType.favoriteItem) {
                                if (notification.targetReview != null) {
                                  var id =
                                      notification.targetReview!.notifiableId;
                                  context.read<ItemDetailBloc>().add(
                                        GetItemDetailEvent(itemId: id),
                                      );
                                  context.pushNamed(
                                    AppRoutes.itemDetail,
                                    pathParameters: {
                                      "itemId": notification
                                          .targetReview!.notifiableId,
                                    },
                                  );
                                }
                              } else if (notification.notifiableType ==
                                  NotificationType.restaurantReview) {
                                context.pushNamed(AppRoutes.restaurantDetail,
                                    pathParameters: {
                                      "restaurantId": notification
                                          .targetReview!.notifiableId,
                                    });
                              } else if (notification.notifiableType ==
                                  NotificationType.itemReview) {
                                context.pushNamed(
                                  AppRoutes.itemDetail,
                                  pathParameters: {
                                    "itemId":
                                        notification.targetReview!.notifiableId,
                                  },
                                );
                              } else if (notification.notifiableType ==
                                  NotificationType.draftReviewReminder) {
                                context
                                    .read<BottomNavigationCubit>()
                                    .changeIndex(4);
                                context.pop();
                              } else if (notification.notifiableType ==
                                  NotificationType.order) {
                                context.pushNamed(
                                  AppRoutes.orderHistoryDetail,
                                  pathParameters: {
                                    'orderId': notification.targetOrder!.id!,
                                  },
                                  extra: {
                                    'restaurantId':
                                        notification.targetOrder!.restaurantId
                                  },
                                );
                              }
                            }
                          : null, //  disable taps if not clickable
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: notification.readStatus
                              ? Colors.white
                              : AppColors.unreadNotificationBackgroundColor,
                          border: Border.all(
                            color: isNotificationClickable(notification)
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Opacity(
                          opacity:
                              isNotificationClickable(notification) ? 1.0 : 0.6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getNotificationIcon(notification),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getNotificationTitle(
                                          notification, context),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                        getNotificationSubTitle(
                                            notification, context),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: medium14.copyWith(),
                                   
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
