import 'dart:io';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/user_engagement_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';

import '../../features/authentication/authentication.dart';
import '../../features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import '../utils/custom_icons_icons.dart';
import 'custom_persistent_bottom_navbar.dart';

class UpdatedBottomNavigationBar extends StatefulWidget {
  const UpdatedBottomNavigationBar({super.key});

  @override
  State<UpdatedBottomNavigationBar> createState() =>
      _UpdatedBottomNavigationBarState();
}

class _UpdatedBottomNavigationBarState
    extends State<UpdatedBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    List<TabItem> items = [
      TabItem(
        icon: CustomIcons.home_2,
        title: AppLocalizations.of(context)!.homeText,
      ),
      TabItem(
        icon: CupertinoIcons.compass,
        title: AppLocalizations.of(context)!.discoverText,
      ),
      TabItem(
        icon: CustomIcons.camera,
        title: AppLocalizations.of(context)!.cameraText,
      ),
      TabItem(
        icon: CustomIcons.searchOutline,
        title: AppLocalizations.of(context)!.searchText,
      ),
      TabItem(
        icon: CustomIcons.user,
        title: AppLocalizations.of(context)!.profileText,
      ),
    ];

    return BlocBuilder<BottomNavigationCubit, int>(
      builder: (context, state) {
        return BottomBarInspiredOutside(
          height: 65,
          boxShadow: elevation_8,
          items: items,
          backgroundColor: Colors.white,
          color: Colors.black54,
          colorSelected: AppColors.textWhite,
          elevation: 12,
          indexSelected: context.read<BottomNavigationCubit>().state,
          onTap: (int index) {
            if (index == 1) {
              context.read<NetworkBloc>().add(NetworkObserve());
            }
            if (index == 2) {
              captureMultipleImages();
            } else {
              var discoverStateCubit =
                  context.read<DiscoverSelectedScreenCubit>();
              var bottomNavCubit = context.read<BottomNavigationCubit>();
              if (discoverStateCubit.state !=
                      DiscoverResultScreens.discoverOptionsPage &&
                  index == 1 &&
                  bottomNavCubit.state == 1) {
                context.goNamed(
                  AppRoutes.home,
                );
                discoverStateCubit.toDiscoverOptionsPage();
              }
              bottomNavCubit.changeIndex(index);
              saveAnalytics(index);
            }
          },
          sizeInside: 50,
          radius: 10,
          top: -20,
          fixed: true,
          fixedIndex: 2,
          itemStyle: ItemStyle.circle,
          chipStyle: const ChipStyle(
            background: AppColors.primaryColor,
            color: Colors.white,
            notchSmoothness: NotchSmoothness.softEdge,
          ),
        );
      },
    );
  }

  void saveAnalytics(int index) {
    final LocalAnalyticsObserver userEngagement =
        dpLocator<LocalAnalyticsObserver>();
    switch (index) {
      case 0:
        userEngagement.updateUserEngagementAnalytics(
            update: UserEngagementAnalytics(homepage: 1));
        break;
      case 3:
        userEngagement.updateUserEngagementAnalytics(
            update: UserEngagementAnalytics(searchPage: 1));
        break;
    }
  }

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  Future<void> captureMultipleImages() async {
    if (getUser()) {
      // Handle camera button press
      context.read<SimpleReviewStepperBloc>().add(
            const SimpleReviewStepperUpdate(
              images: [],
              videos: [],
            ),
          );

      final requestGranted = await requestCameraPermission();
      if (requestGranted && mounted) {
        context.pushNamed(AppRoutes.quickAddReviewFileSelect);
      } else {
        _handlePermissionDenied();
      }
    } else {
      _showLoginDialog(context);
    }
  }

  Future<bool> requestCameraPermission() async {
    if (Platform.isIOS) return true;
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus == PermissionStatus.granted) {
      // Permission granted, proceed with using the camera
      // setState(() {}); // Rebuild the widget to trigger camera usage
      await Permission.storage.request();
      return true;
    } else {
      // Handle denied permission
      _handlePermissionDenied();
      return false;
    }
  }

  void _handlePermissionDenied() {
    // Show a message and/or button to guide the user to settings
    showCustomToast(
      context: context,
      toastMessage: AppLocalizations.of(context)!.noCameraPermission,
      toastType: ToastType.error,
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.loginRequiredText,
          ),
          content: Text(AppLocalizations.of(context)!.loginNeededText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.cancelText),
            ),
            TextButton(
              onPressed: () {
                var routeInfo = {
                  "routeName": AppRoutes.quickAddReviewFileSelect,
                };
                Navigator.of(ctx).pop(); // Close the dialog
                context.pushNamed(
                  AppRoutes.login,
                  extra: routeInfo,
                );
              },
              child: Text(AppLocalizations.of(context)!.loginText),
            ),
          ],
        );
      },
    );
  }
}
