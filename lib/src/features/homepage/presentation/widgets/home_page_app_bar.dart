import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_persistent_bottom_navbar.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  int countUnreadNotifications(List<NotificationEntity> notifications) {
    int unreadCount = 0;
    for (var notification in notifications) {
      if (!notification.readStatus) unreadCount++;
    }
    return unreadCount;
  }

  String getGreetingMessage(context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context)!.goodMorningText;
    } else if (hour < 18) {
      return AppLocalizations.of(context)!.goodAfternoonText;
    } else {
      return AppLocalizations.of(context)!.goodEveningText;
    }
  }

  // Helper widget to build icon with badge
  Widget _buildIconWithBadge({
    required Widget icon,
    required int count,
    required VoidCallback onPressed,
    EdgeInsets padding = const EdgeInsets.all(12.0),
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: padding,
          child: GestureDetector(
            onTap: onPressed,
            child: icon,
          ),
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.primaryColor,
              child: Text(
                "$count",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              final bottomNavCubit = context.read<BottomNavigationCubit>();
              bottomNavCubit.changeIndex(4);
              context.goNamed(AppRoutes.home);
            },
            child: ClipOval(
              child: Container(
                alignment: Alignment.center,
                width: 27.sp,
                height: 27.sp,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.1),
                ),
                child: (user != null && (user.image ?? "").isNotEmpty)
                    ? CachedNetworkImage(
                        fadeInCurve: Curves.easeIn,
                        width: 27.sp,
                        height: 27.sp,
                        fit: BoxFit.cover,
                        imageUrl: user.image!,
                        errorWidget: (context, url, error) {
                          return Text(
                            user.firstName![0],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              fontSize: 17.sp,
                            ),
                          );
                        },
                      )
                    : Text(
                        user != null ? user.firstName![0] : "N",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                          fontSize: 17.sp,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          // Welcome Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getGreetingMessage(context), style: semiBold14),
              Text(
                user?.firstName ?? AppLocalizations.of(context)!.welcomeText,
                style: medium14,
              ),
            ],
          ),
          const Spacer(),
          // Notification Icon with badge
          if (getUser())
            BlocBuilder<UnreadNotificationsCounterBloc,
                UnreadNotificationsCounterState>(
              builder: (context, notificationState) {
                if (notificationState is UnreadNotificationsCounterLoading) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.grey100,
                    highlightColor: AppColors.shimmerHighlightColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notification_add),
                        onPressed: () {},
                      ),
                    ),
                  );
                } else if (notificationState
                    is UnreadNotificationsCounterFetched) {
                  return _buildIconWithBadge(
                    icon: SvgPicture.asset(
                      "assets/icons/Notification.svg",
                      height: 3.h,
                      width: 5.w,
                    ),
                    count: notificationState.count,
                    onPressed: () async {
                      if (getUser()) {
                        final user = dpLocator<AuthenticationLocalSource>()
                            .getUserCredential();

                        context
                            .read<NotificationsBloc>()
                            .add(GetUserNotifications(userId: user!.id!));
                        await context.pushNamed(AppRoutes.notificationPage);
                        if (context.mounted) {
                          context.read<UnreadNotificationsCounterBloc>().add(
                              GetUnreadNotificationsCount(userId: user.id!));
                        }
                      }
                    },
                  );
                }
                // Default icon without badge
                return _buildIconWithBadge(
                  icon: SvgPicture.asset(
                    "assets/icons/Notification.svg",
                    height: 3.h,
                    width: 5.w,
                  ),
                  count: 0,
                  onPressed: () async {
                    if (getUser()) {
                      final user = dpLocator<AuthenticationLocalSource>()
                          .getUserCredential();

                      context
                          .read<NotificationsBloc>()
                          .add(GetUserNotifications(userId: user!.id!));
                      await context.pushNamed(AppRoutes.notificationPage);
                      if (context.mounted) {
                        context
                            .read<UnreadNotificationsCounterBloc>()
                            .add(GetUnreadNotificationsCount(userId: user.id!));
                      }
                    }
                  },
                );
              },
            ),
          if (getUser())
            // Order history icon with badge
            BlocBuilder<OrdersCountBloc, OrdersCountState>(
              builder: (context, ordersCountState) {
                if (ordersCountState is OrdersCountLoading) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.grey100,
                    highlightColor: AppColors.shimmerHighlightColor,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delivery_dining_outlined),
                        onPressed: () {},
                      ),
                    ),
                  );
                } else if (ordersCountState is OrdersCountLoaded) {
                  return _buildIconWithBadge(
                    icon: SvgPicture.asset(
                      "assets/icons/order_bag.svg",
                      height: 3.h,
                      width: 5.w,
                    ),
                    count: ordersCountState.count,
                    onPressed: () {
                      context.pushNamed(AppRoutes.orderHistory);
                    },
                  );
                }
                // Default order icon without badge
                return IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/order_bag.svg",
                    height: 3.h,
                    width: 5.w,
                  ),
                  onPressed: () {
                    context.pushNamed(AppRoutes.orderHistory);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(100.w, 8.h);
}
