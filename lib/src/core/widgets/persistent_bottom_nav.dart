// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/core/core.dart';
// import 'package:rateeat_mobile/src/core/widgets/login_redirect_page.dart';
// import 'package:rateeat_mobile/src/core/widgets/open_location_setting.dart';

// import 'package:rateeat_mobile/src/features/features.dart';
// import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
// import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/nearby_restaurant_search_page.dart';
// import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

// import '../../features/discover_item/presentation/pages/item_result_page.dart';
// import '../../features/discover_restaurant_result/presentation/pages/discover_result_page.dart';
// import '../../features/notification/presentation/bloc/notification_bloc.dart';
// import '../../features/search_result/presentation/pages/search_result_page.dart';
// import 'custom_persistent_bottom_navbar.dart';

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({
//     super.key,
//     this.initialPage,
//     this.fromOtherPages,
//   });

//   final int? initialPage;
//   final String? fromOtherPages;

//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   late final PersistentTabController _controller;
//   int? _currentIndex;

//   @override
//   void initState() {
//     _currentIndex = widget.initialPage ?? 1;
//     _controller =
//         PersistentTabController(initialIndex: widget.initialPage ?? 1);
//     super.initState();
//   }

//   bool getUser() {
//     try {
//       final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
//       if (user != null && _currentIndex == 0) {
//         context.read<NotificationsBloc>().add(
//               GetUserNotifications(userId: user.id!),
//             );
//       }
//       return user != null;
//     } on CacheException {
//       return false;
//     }
//   }

//   Future<void> captureMultipleImages() async {
//     if (getUser()) {
//       // Handle camera button press
//       context.read<SimpleReviewStepperBloc>().add(
//             const SimpleReviewStepperUpdate(
//               images: [],
//               videos: [],
//             ),
//           );
//       context.pushNamed(AppRoutes.quickAddReviewFileSelect);
//     } else {
//       showCustomToast(context: context, toastMessage: "login is required");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: buildBottomNavBar(context),
//     );
//   }

//   buildBottomNavBar(BuildContext context) {
//     return BlocBuilder<DiscoverSelectedScreenCubit, DiscoverResultScreens>(
//       builder: (context, discoverState) {
//         return BlocConsumer<UserLocationBloc, UserLocationState>(
//           listener: (context, userLocationState) async {
//             if (userLocationState is UserLocationError) {
//               final permission = await Geolocator.checkPermission();
//               if (permission == LocationPermission.denied) {
//                 if (context.mounted) {
//                   showLocationPermissionDialog(context: context);
//                 }
//               }
//               if (context.mounted) {
//                 showCustomToast(
//                     context: context,
//                     toastMessage: userLocationState.message,
//                     backgroundColor: Colors.red);
//               }
//             }
//           },
//           builder: (context, state) {
//             return PersistentTabView(
//               context,
//               screens: _buildScreens(),
//               controller: _controller,
//               items: _navBarsItems(),
//               navBarHeight: SizeConfig.screenHeight * 0.08,
//               confineInSafeArea: true,
//               backgroundColor: Colors.white, // Default is Colors.white.
//               handleAndroidBackButtonPress: false, // Default is true.
//               onWillPop: (p0) async {
//                 context.goNamed(AppRoutes.home);
//                 context
//                     .read<DiscoverSelectedScreenCubit>()
//                     .toDiscoverOptionsPage();
//                 return true;
//               },
//               resizeToAvoidBottomInset: true,
//               stateManagement: true,

//               hideNavigationBarWhenKeyboardShows: true,
//               decoration: const NavBarDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10.0),
//                     topRight: Radius.circular(10.0)),
//                 colorBehindNavBar: Colors.white,
//               ),
//               popAllScreensOnTapOfSelectedTab: true,
//               popActionScreens: PopActionScreensType.all,
//               itemAnimationProperties: const ItemAnimationProperties(
//                 duration: Duration(milliseconds: 200),
//                 curve: Curves.ease,
//               ),
//               screenTransitionAnimation: const ScreenTransitionAnimation(
//                 animateTabTransition: true,
//                 curve: Curves.ease,
//                 duration: Duration(milliseconds: 200),
//               ),
//               onItemSelected: (index) {
//                 setState(() {});

//                 if (_currentIndex == 1 && index == 1) {
//                   context
//                       .read<DiscoverSelectedScreenCubit>()
//                       .toDiscoverOptionsPage();
//                 }

//                 _currentIndex = index;
//                 _controller.index = index;
//               },
//               navBarStyle: NavBarStyle
//                   .style15, // Choose the nav bar style with this property.
//             );
//           },
//         );
//       },
//     );
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: ColorFiltered(
//           colorFilter: ColorFilter.mode(
//             _currentIndex == 0 ? const Color(0XFFFF3008) : AppColors.grey400,
//             BlendMode.srcIn,
//           ),
//           child: SvgPicture.asset(
//             "assets/icons/home-2.svg",
//             fit: BoxFit.contain,
//           ),
//         ),
//         textStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         title: AppLocalizations.of(context)!.homeText,
//         activeColorPrimary: const Color(0XFFFF3008),
//         inactiveColorPrimary: AppColors.grey400,
//       ),
//       PersistentBottomNavBarItem(
//         icon: ColorFiltered(
//           colorFilter: ColorFilter.mode(
//             _currentIndex == 1 ? const Color(0XFFFF3008) : AppColors.grey400,
//             BlendMode.srcIn,
//           ),
//           child: SvgPicture.asset(
//             "assets/icons/discover.svg",
//             fit: BoxFit.contain,
//           ),
//         ),
//         textStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         title: AppLocalizations.of(context)!.discoverText,
//         activeColorPrimary: const Color(0XFFFF3008),
//         inactiveColorPrimary: AppColors.grey400,
//       ),
//       PersistentBottomNavBarItem(
//         onPressed: (ctx) {
//           captureMultipleImages();
//         },
//         icon: Container(
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 width: 2,
//                 color: _currentIndex == 2
//                     ? const Color(0XFFFF3008)
//                     : AppColors.grey400,
//               )),
//           child: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: 20,
//             child: ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == 2
//                     ? const Color(0XFFFF3008)
//                     : AppColors.grey400,
//                 BlendMode.srcIn,
//               ),
//               child: Icon(
//                 Icons.camera_outlined,
//                 size: 20,
//                 color: _currentIndex == 2
//                     ? const Color(0XFFFF3008)
//                     : AppColors.grey400,
//               ),
//             ),
//           ),
//         ),
//         textStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color:
//               _currentIndex == 2 ? const Color(0XFFFF3008) : AppColors.grey400,
//         ),
//         title: AppLocalizations.of(context)!.quickReviewText,
//         activeColorSecondary: const Color(0XFFFF3008),
//         activeColorPrimary: Colors.transparent,
//         inactiveColorPrimary: AppColors.grey400,
//         iconSize: 5,
//       ),
//       PersistentBottomNavBarItem(
//         icon: ColorFiltered(
//           colorFilter: ColorFilter.mode(
//             _currentIndex == 3 ? const Color(0XFFFF3008) : AppColors.grey400,
//             BlendMode.srcIn,
//           ),
//           child: SvgPicture.asset(
//             "assets/icons/search.svg",
//             fit: BoxFit.contain,
//           ),
//         ),
//         textStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         title: AppLocalizations.of(context)!.searchText,
//         activeColorPrimary: const Color(0XFFFF3008),
//         inactiveColorPrimary: AppColors.grey400,
//       ),
//       PersistentBottomNavBarItem(
//         icon: ColorFiltered(
//           colorFilter: ColorFilter.mode(
//             _currentIndex == 4 ? const Color(0XFFFF3008) : AppColors.grey400,
//             BlendMode.srcIn,
//           ),
//           child: SvgPicture.asset(
//             "assets/icons/user.svg",
//             fit: BoxFit.contain,
//           ),
//         ),
//         textStyle: GoogleFonts.poppins(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//         title: AppLocalizations.of(context)!.profileText,
//         activeColorPrimary: const Color(0XFFFF3008),
//         inactiveColorPrimary: AppColors.grey400,
//       )
//     ];
//   }

//   List<Widget> _buildScreens() {
//     final Map<DiscoverResultScreens, Widget> discoverScreenOptions = {
//       DiscoverResultScreens.discoverOptionsPage: const DiscoverScreen(),
//       DiscoverResultScreens.discoverRestaurantResultPage:
//           const DiscoverResultPage(),
//       DiscoverResultScreens.discoverItemsResultPage: const ItemResultPage(),
//     };

//     var currentScreen = context.read<DiscoverSelectedScreenCubit>().state;
//     return [
//       const HomePage(),
//       discoverScreenOptions[currentScreen]!,
//       const NearByRestaurantSearchPage(),
//       const RestaurantResultPage(),
//       getUser() ? const UserProfile() : const RedirectLoginWidget()
//     ];
//   }
// }
