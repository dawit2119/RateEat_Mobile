import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../authentication/authentication.dart';
import '../../../item_detail/item_detail.dart';
import '../../../item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import '../bloc/fetch_notifications/notification_bloc.dart';
import '../bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';
import 'item_detail_display.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../domain/entities/notification.dart';
import 'review_card.dart';
import '../../../../core/core.dart';

class NotificationsPageBottomSheet extends StatefulWidget {
  final NotificationEntity notification;
  const NotificationsPageBottomSheet({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationsPageBottomSheet> createState() =>
      _NotificationsPageBottomSheetState();
}

class _NotificationsPageBottomSheetState
    extends State<NotificationsPageBottomSheet> {
  String getTitleMessage({required NotificationType notificationType}) {
    switch (notificationType) {
      case NotificationType.favoriteItem:
        return AppLocalizations.of(context)!.favoriteItemCommentMessage;
      case NotificationType.itemReview:
        return AppLocalizations.of(context)!.itemReviewUpVoteReactionText;
      case NotificationType.restaurantReview:
        return AppLocalizations.of(context)!.restaurantReviewUpVoteReactionText;
      case NotificationType.draftReviewReminder:
        return AppLocalizations.of(context)!.draftReviewText;
      case NotificationType.incentive:
        return AppLocalizations.of(context)!.incentivizeText;
      case NotificationType.order:
        return "Order";
      case NotificationType.follow:
        return "Follow";
      case NotificationType.general:
        return "General";
    }
  }

  @override
  void initState() {
    final currentUser =
        dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (!widget.notification.readStatus) {
      context.read<NotificationsMarkAsReadBloc>().add(
            MarkNotificationStatusAsRead(
                notificationId: widget.notification.id),
          );
      context.read<UnreadNotificationsCounterBloc>().add(
            GetUnreadNotificationsCount(
              userId: currentUser!.id!,
            ),
          );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationActionsSuccess ||
            state is NotificationActionsFailed) {
          final user =
              dpLocator<AuthenticationLocalSource>().getUserCredential();

          context.read<NotificationsBloc>().add(
                GetUserNotifications(
                  userId: user!.id!,
                ),
              );
        }
      },
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              20.sp,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.notification.notifiableType ==
                    NotificationType.favoriteItem)
                  BlocBuilder<ItemDetailBloc, ItemDetailState>(
                    builder: (context, state) {
                      if (state is ItemDetailLoading) {
                        return Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                20.sp,
                              ),
                            ),
                          ),
                          child: Center(
                            child: LoadingAnimationWidget.dotsTriangle(
                              color: AppColors.primaryColor,
                              size: screenHeight * 0.04,
                            ),
                          ),
                        );
                      } else if (state is ItemDetailSuccess) {
                        return Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                20.sp,
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10.sp),
                                  width: 26.sp,
                                  height: 8.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                verticalPadding(height: 3),
                                Text(
                                  getTitleMessage(
                                    notificationType:
                                        widget.notification.notifiableType,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textDark,
                                    height: 1.1,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                verticalPadding(height: .6),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.notification.notifiableType ==
                                          NotificationType.favoriteItem)
                                        ItemDetailDisplay(
                                          item: state.item,
                                        ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * .07,
                                          vertical: 4,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.notification
                                                          .notifiableType ==
                                                      NotificationType
                                                          .favoriteItem
                                                  ? "${AppLocalizations.of(context)!.newReviewText}:"
                                                  : "${AppLocalizations.of(context)!.yourReviewText}:",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.textDark,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            ReviewCard(
                                              notification: widget.notification,
                                              itemReview: widget
                                                  .notification.targetReview,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * .5,
                                  child: CustomMainButton(
                                    title: "See Details",
                                    onTap: () {
                                      if (widget.notification.notifiableType ==
                                          NotificationType.restaurantReview) {
                                        context.pop();
                                        context.pushNamed(
                                            AppRoutes.restaurantDetail,
                                            pathParameters: {
                                              "restaurantId": widget
                                                  .notification
                                                  .targetReview!
                                                  .notifiableId,
                                            });
                                      } else {
                                        context.pop();
                                        context.pushNamed(
                                          AppRoutes.itemDetail,
                                          pathParameters: {
                                            "itemId": widget.notification
                                                .targetReview!.notifiableId,
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                verticalPadding(height: 2),
                              ],
                            ),
                          ),
                        );
                      } else if (state is ItemDetailError) {
                        return ErrorAndInfoDisplayWidget(
                          assetImage: "assets/icons/no_content.svg",
                          title: AppLocalizations.of(context)!
                              .canTGetItemDetailText,
                          description:
                              AppLocalizations.of(context)!.tryAgainText,
                          onPressed: () {
                            context.read<ItemDetailBloc>().add(
                                  GetItemDetailEvent(
                                    itemId: widget.notification.targetReview!
                                        .notifiableId,
                                  ),
                                );
                          },
                        );
                      }
                      return ErrorAndInfoDisplayWidget(
                        assetImage: "assets/icons/no_content.svg",
                        title: AppLocalizations.of(context)!.canTGetReviewText,
                        description: AppLocalizations.of(context)!.tryAgainText,
                        onPressed: () {
                          context.read<ItemDetailBloc>().add(
                                GetItemDetailEvent(
                                  itemId: widget
                                      .notification.targetReview!.notifiableId,
                                ),
                              );
                        },
                      );
                    },
                  ),
                if (widget.notification.notifiableType ==
                    NotificationType.draftReviewReminder)
                  Container(
                    height: 30.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          20.sp,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.sp),
                          width: 26.sp,
                          height: 8.sp,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        verticalPadding(height: 3),
                        Text(
                          getTitleMessage(
                            notificationType:
                                widget.notification.notifiableType,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: AppColors.textDark,
                            height: 1.1,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        verticalPadding(height: 1),
                        SizedBox(
                          width: screenWidth * .5,
                          child: CustomMainButton(
                            title: AppLocalizations.of(context)!.finishText,
                            onTap: () {
                              context.pushReplacementNamed(
                                AppRoutes.profile,
                              );
                            },
                          ),
                        ),
                        verticalPadding(height: 2),
                      ],
                    ),
                  ),
                if (widget.notification.notifiableType ==
                    NotificationType.incentive)
                  Container(
                    height: 40.h,
                    padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          20.sp,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.sp),
                          width: 26.sp,
                          height: 8.sp,
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          getTitleMessage(
                            notificationType:
                                widget.notification.notifiableType,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: AppColors.textDark,
                            height: 1.1,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: .6.h),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(
                                  0.7,
                                ), // Adjust opacity for glow effect
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.notification.message,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              height: 1.3,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        SizedBox(
                          width: screenWidth * .5,
                          child: CustomMainButton(
                            title: AppLocalizations.of(context)!.closeText,
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                if (widget.notification.notifiableType ==
                        NotificationType.itemReview ||
                    widget.notification.notifiableType ==
                        NotificationType.restaurantReview)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.sp),
                        width: 26.sp,
                        height: 8.sp,
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      verticalPadding(height: 3),
                      Text(
                        "${widget.notification.reactor.firstName} ${getTitleMessage(
                          notificationType: widget.notification.notifiableType,
                        )}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          height: 1.1,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalPadding(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * .08,
                                vertical: 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.notification.notifiableType ==
                                            NotificationType.favoriteItem
                                        ? "${AppLocalizations.of(context)!.newReviewText}:"
                                        : "${AppLocalizations.of(context)!.yourReviewText}:",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textDark,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  ReviewCard(
                                    notification: widget.notification,
                                    itemReview:
                                        widget.notification.targetReview,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * .5,
                        child: CustomMainButton(
                          title: AppLocalizations.of(context)!.seeText,
                          onTap: () {
                            context.pop();
                            if (widget.notification.notifiableType ==
                                NotificationType.restaurantReview) {
                              context.pushNamed(AppRoutes.restaurantDetail,
                                  pathParameters: {
                                    "restaurantId": widget.notification
                                        .targetReview!.notifiableId,
                                  });
                            } else {
                              context.pushNamed(AppRoutes.itemDetail,
                                  pathParameters: {
                                    "itemId": widget.notification.targetReview!
                                        .notifiableId,
                                  });
                            }
                          },
                        ),
                      ),
                      verticalPadding(height: 2),
                    ],
                  ),
              ]),
        ),
      ),
    );
  }
}
