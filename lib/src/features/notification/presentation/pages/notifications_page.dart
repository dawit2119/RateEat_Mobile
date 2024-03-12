import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../authentication/authentication.dart';
import '../bloc/fetch_notifications/notification_bloc.dart';
import '../widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  final LocalUserModel? user;
  const NotificationPage({super.key, this.user});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _notificationsPageScrollController = ScrollController();

  @override
  void initState() {
    _notificationsPageScrollController.addListener(_onNotificationsPageScroll);
    context.read<NotificationsPageCubit>().changePage(1);
    if (widget.user != null) {
      context.read<NotificationsBloc>().add(
            GetUserNotifications(
              userId: widget.user!.id!,
            ),
          );
    }
    super.initState();
  }

  void _onNotificationsPageScroll() {
    final state = context.read<NotificationsBloc>().state;
    final currentPage = context.read<NotificationsPageCubit>().state;
    final currentUser =
        dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (state is NotificationsLoaded &&
        state.hasReachedMax &&
        _isBottomReached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No more notification"),
        ),
      );
      return;
    } else if (state is NotificationsLoaded &&
        !state.hasReachedMax &&
        _isBottomReached) {
      context.read<NotificationsPageCubit>().changePage(
            currentPage + 1,
          );
      context.read<NotificationsBloc>().add(
            GetUserNotifications(
              userId: currentUser!.id!,
              page: currentPage + 1,
            ),
          );
    }
  }

  bool get _isBottomReached {
    if (!_notificationsPageScrollController.hasClients) return false;
    return _notificationsPageScrollController.position.maxScrollExtent ==
        _notificationsPageScrollController.position.pixels;
  }

  @override
  void dispose() {
    super.dispose();
    _notificationsPageScrollController
      ..removeListener(_onNotificationsPageScroll)
      ..dispose();
  }

  Future refresh() {
    context.read<NotificationsPageCubit>().changePage(
          1,
        );
    final currentUser =
        dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (currentUser != null) {
      context.read<NotificationsBloc>().add(
            GetUserNotifications(
              userId: currentUser.id!,
            ),
          );
    }
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: refresh,
      child: Scaffold(
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.notificationText,
            onTap: () {
              context.goNamed(AppRoutes.home, extra: {
                'id': 0,
              });
            },
          ),
          body: SingleChildScrollView(
            controller: _notificationsPageScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: BlocConsumer<NotificationsBloc, NotificationsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return SizedBox(
                      height: 85.h,
                      child: Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          key: const Key("NotificationsLoadingAnimationWidget"),
                          color: AppColors.primaryColor,
                          size: screenHeight * 0.04,
                        ),
                      ),
                    );
                  } else if (state is NotificationsNextLoading) {
                    return Column(
                      children: [
                        Column(
                          children: state.notifications.entries
                              .map(
                                (notificationEntry) => NotificationTile(
                                  notifications: notificationEntry.value,
                                  createdAt: notificationEntry.key,
                                ),
                              )
                              .toList(),
                        ),
                        Center(
                          child: LoadingAnimationWidget.dotsTriangle(
                            color: AppColors.primaryColor,
                            size: screenHeight * 0.03,
                          ),
                        ),
                      ],
                    );
                  } else if (state is NotificationsLoaded) {
                    final notificationsPageCurrentPageCubit =
                        context.read<NotificationsPageCubit>();
                    if (!state.fetchingStatus) {
                      notificationsPageCurrentPageCubit.changePage(
                          notificationsPageCurrentPageCubit.state - 1);
                    }
                    return state.notifications.isEmpty
                        ? Center(
                            key: const Key("NoNewNotifications"),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .noNewNotificationsText,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Column(
                            key: Key("list_of_all_notifications"),
                            children: state.notifications.entries
                                .map(
                                  (notificationEntry) => NotificationTile(
                                    notifications: notificationEntry.value,
                                    createdAt: notificationEntry.key,
                                  ),
                                )
                                .toList(),
                          );
                  } else if (state is NotificationActionsFailed) {
                    return ErrorAndInfoDisplayWidget(
                      assetImage: "assets/icons/no_content.svg",
                      title:
                          AppLocalizations.of(context)!.notificationsErrorText,
                      description: AppLocalizations.of(context)!.tryAgainText,
                      onPressed: () {
                        final user = dpLocator<AuthenticationLocalSource>()
                            .getUserCredential();

                        if (user != null) {
                          context.read<NotificationsBloc>().add(
                                GetUserNotifications(
                                  userId: user.id!,
                                ),
                              );
                        }
                      },
                    );
                  }
                  return Text(
                    state.toString(),
                  );
                },
              ),
            ),
          )),
    );
  }
}

class NotificationsPageCubit extends Cubit<int> {
  NotificationsPageCubit() : super(1);
  void changePage(page) => emit(page);
}
