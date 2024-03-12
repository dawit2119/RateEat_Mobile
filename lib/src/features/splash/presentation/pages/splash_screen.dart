import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_crachlytics.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';

class SplashScreen extends StatefulWidget {
  final Map<String, dynamic> notificationStatus;
  const SplashScreen({super.key, this.notificationStatus = const {}});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.notificationStatus.isNotEmpty) {
        _redirectToInitialRoute();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<NetworkBloc, NetworkState>(
      listener: (context, networkState) {
        if (networkState is NetworkFailed) {
          showCustomToast(
            context: context,
            toastMessage: AppLocalizations.of(context)!.networkText,
            toastType: ToastType.warning,
          );
        } else if (networkState is NetworkSuccess) {
          _redirectToInitialRoute();
        }
      },
      builder: (context, networkState) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                child: Gif(
                  height: 20.h,
                  width: screenWidth,
                  controller: _controller,
                  duration: const Duration(seconds: 2),
                  image: const AssetImage(
                    'assets/gifs/splash_outlined.gif',
                  ),
                  onFetchCompleted: () {
                    _controller.reset();
                    _controller.forward().then((value) {
                      context.read<NetworkBloc>().add(NetworkObserve());
                    });
                  },
                ),
              ),
              //* Loading indicator for Network
              if (networkState is! NetworkFailed &&
                  networkState is! NetworkInitial)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Connecting...",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withRed(100),
                      letterSpacing: -.2,
                    ),
                  ),
                ),
              //* If Network Failure
              if (networkState is NetworkFailed &&
                  networkState is! NetworkInitial)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomMainButton(
                    title: "Check Connection",
                    onTap: () {
                      context.read<NetworkBloc>().add(NetworkObserve());
                    },
                    horizontalPadding: 2.w,
                  ),
                ),
              SizedBox(
                height: 2.h,
              ),
              // TODO: uncomment the code below when local caching features are fully functional
              // if (networkState is NetworkFailed &&
              //     networkState is! NetworkInitial)
              //   Align(
              //     alignment: Alignment.bottomCenter,
              //     child: GestureDetector(
              //       onTap: () {
              //         _redirectToInitialRoute();
              //       },
              //       child: const Text(
              //         "Continue offline",
              //         style: TextStyle(color: AppColors.primaryColor),
              //       ),
              //     ),
              //   ),
              SizedBox(
                height: screenHeight * 0.08,
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to redirect to the initial route
  void _redirectToInitialRoute() {
    final route = getInitialRoute(widget.notificationStatus);
    if (route == AppRoutes.notificationPage) {
      context.read<UnreadNotificationsCounterBloc>().add(
            GetUnreadNotificationsCount(
              userId: widget.notificationStatus['userId'],
            ),
          );
      context.read<NotificationsBloc>().add(
            GetUserNotifications(userId: widget.notificationStatus['userId']),
          );
    }
    context.pushReplacementNamed(
      route,
    );
  }

  String getInitialRoute(Map<String, dynamic> notificationStatus) {
    final appLaunchStateBox = Hive.box<bool>('appLaunchState');
    final isFirstLaunch = appLaunchStateBox.get(0);
    if (isFirstLaunch == null || isFirstLaunch) {
      // First-time app launch, show the onboarding screen.
      return AppRoutes.onboarding;
    } else {
      setUser();
      // App has been launched before, show your main content.
      if (notificationStatus.isNotEmpty) {
        return AppRoutes.notificationPage;
      }
      return AppRoutes.home;
    }
  }

  void setUser() {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (user != null) {
      dpLocator<AnalyticsObserver>().setUserId(userId: user.id!);
      dpLocator<FirebaseCrashLogger>().setUserIdentifier(userId: user.id!);
    }
  }

  Future<void> loadSvgImages() async {
    final List<Uint8List> svgImages = await loadAsset();
    final svgImageBox = Hive.box<Uint8List>('svgImages');
    svgImageBox.put(0, svgImages as Uint8List);
  }

  Future<List<Uint8List>> loadAsset() async {
    final Directory svgDirectory =
        Directory('lib/assets/svg'); // Adjust the path accordingly
    final List<FileSystemEntity> entities = await svgDirectory.list().toList();

    // Filter only files
    final List<File> svgFiles = entities.whereType<File>().toList();

    // Load the SVG files
    final List<Uint8List> svgImages = await Future.wait<Uint8List>(
      svgFiles.map(
        (File file) async {
          final Uint8List rawSvg = await file.readAsBytes();
          return rawSvg;
        },
      ),
    );
    return svgImages;
  }
}
