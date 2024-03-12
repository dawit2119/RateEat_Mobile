// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/core/widgets/error_display_section.dart';
// import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/restaurant_review_card.dart';
// import 'package:rateeat_mobile/src/features/review_page/bloc/restaurant_review_bloc/restaurant_review_bloc.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:video_player/video_player.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';
// import '../../../review_page/bloc/restaurant_review_bloc/restaurant_review_event.dart';
// import '../../../review_page/bloc/restaurant_review_bloc/restaurant_review_state.dart';
// import '../../../user_profile/user_profile.dart';

// class RestaurantInfoBottomSheet extends StatefulWidget {
//   final Restaurant restaurant;
//   const RestaurantInfoBottomSheet({
//     super.key,
//     required this.restaurant,
//   });

//   @override
//   State<RestaurantInfoBottomSheet> createState() => _RestaurantInfoBottomSheetState();
// }

// class _RestaurantInfoBottomSheetState extends State<RestaurantInfoBottomSheet>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     context
//         .read<RestaurantReviewsBloc>()
//         .add(GetRestaurantReviewsEvent(restaurantId: widget.restaurant.id!));
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var phoneNumber = widget.restaurant.restaurantPhoneNumbers != null &&
//             widget.restaurant.restaurantPhoneNumbers!.isNotEmpty
//         ? formatPhoneNumber(widget.restaurant.restaurantPhoneNumbers![0]['phone_number'])
//         : '';

//     return DraggableScrollableSheet(
//       snap: true,
//       initialChildSize: .5,
//       minChildSize: .5,
//       maxChildSize: 1,
//       snapSizes: const [.5, 1],
//       builder: (BuildContext context, ScrollController scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(16),
//           ),
//         ),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned.fill(
//               child: ListView(
//                 controller: scrollController,
//                 physics: const ClampingScrollPhysics(parent: BouncingScrollPhysics()),
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 32,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: AppColors.grey200,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             verticalPadding(height: 2),
//                             Text(
//                               widget.restaurant.name!,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.poppins(
//                                 color: AppColors.textDark,
//                                 height: 1.2,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             verticalPadding(height: 1),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.star_rounded,
//                                   color: AppColors.primaryColor,
//                                 ),
//                                 horizontalPadding(width: .2),
//                                 Text(
//                                   "${widget.restaurant.averageRating}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 horizontalPadding(width: 1),
//                                 Text(
//                                   "(${widget.restaurant.numberOfReviews} ${AppLocalizations.of(context)!.revText})",
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.grey400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             verticalPadding(height: .2),
//                             // Walking Distance display
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.directions_walk_rounded,
//                                   color: AppColors.grey400,
//                                   size: 16,
//                                 ),
//                                 horizontalPadding(width: .4),
//                                 Text(
//                                   "${widget.restaurant.walkingTime} ${AppLocalizations.of(context)!.walkingDistanceText}",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.grey400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             verticalPadding(height: 2),
//                             RestaurantServiceCard(
//                               title: AppLocalizations.of(context)!.userReviewText,
//                               info:
//                                   "${widget.restaurant.numberOfReviews} ${AppLocalizations.of(context)!.revText}",
//                               iconPath: "assets/icons/star.svg",
//                               onTap: () {
//                                 // ! TODO: Navigate to the restaurant review page
//                                 // context.read<RestaurantMenuBloc>().add(
//                                 //       GetRestaurantMenuCategoryItems(
//                                 //         restaurantId: restaurant.id!,
//                                 //       ),
//                                 //     );
//                                 context.pushNamed(
//                                   AppRoutes.restaurantMenu,
//                                   extra: widget.restaurant,
//                                 );
//                               },
//                             ),
//                             RestaurantServiceCard(
//                               title: AppLocalizations.of(context)!.openinghrText,
//                               iconPath: "assets/icons/clock_rectangle.svg",
//                               leftWidget: _getOpeningHoursWidget(widget.restaurant, context),
//                               info: "",
//                             ),
//                             widget.restaurant.restaurantPhoneNumbers != null &&
//                                     widget.restaurant.restaurantPhoneNumbers!.isNotEmpty
//                                 ? RestaurantServiceCard(
//                                     title: AppLocalizations.of(context)!.callText,
//                                     info: phoneNumber,
//                                     showDivider: false,
//                                     iconPath: "assets/icons/call.svg",
//                                     onTap: () async {
//                                       await makePhoneCall(phoneNumber);
//                                     },
//                                   )
//                                 : Container(),
//                             verticalPadding(height: 2),
//                             CustomTabBar(
//                               height: 60,
//                               tabBar: TabBar(
//                                 controller: _tabController,
//                                 indicatorPadding:
//                                     const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                                 dividerColor: Colors.transparent,
//                                 indicatorSize: TabBarIndicatorSize.tab,
//                                 indicator: BoxDecoration(
//                                   color: Colors.white,
//                                   boxShadow: elevation_2,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 physics:
//                                     const BouncingScrollPhysics(parent: FixedExtentScrollPhysics()),
//                                 tabs: [
//                                   _buildTab("Images"),
//                                   _buildTab(AppLocalizations.of(context)!.userReviewText),
//                                 ],
//                               ),
//                             ),
//                             verticalPadding(height: 2),
//                             SizedBox(
//                               height: 100.w,
//                               child: TabBarView(
//                                 controller: _tabController,
//                                 children: [
//                                   Builder(builder: (context) {
//                                     if (widget.restaurant.restaurantImages == null ||
//                                         widget.restaurant.restaurantImages!.isEmpty) {
//                                       return Center(
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 color: AppColors.grey200,
//                                                 boxShadow: elevation_4,
//                                               ),
//                                               child: ClipRRect(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 child: SvgPicture.asset(
//                                                   "assets/images/no_camera_access.svg",
//                                                   height: 100,
//                                                   width: 100,
//                                                   fit: BoxFit.fill,
//                                                 ),
//                                               ),
//                                             ),
//                                             verticalPadding(height: 3),
//                                             const Text("No images of restaurant",
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                 )),
//                                           ],
//                                         ),
//                                       );
//                                     }
//                                     return MasonryGridView.count(
//                                       crossAxisCount: 2,
//                                       crossAxisSpacing: 10,
//                                       mainAxisSpacing: 10,
//                                       physics: const BouncingScrollPhysics(),
//                                       itemCount: widget.restaurant.restaurantImages!.length +
//                                           widget.restaurant.restaurantVideos!.length,
//                                       itemBuilder: (context, index) {
//                                         if (index < widget.restaurant.restaurantImages!.length) {
//                                           // ? TODO: Add image viewer
//                                           return GestureDetector(
//                                             onTap: () async {
//                                               await showDialog(
//                                                 context: context,
//                                                 builder: (_) => ImageDialog(
//                                                   pageController: PageController(initialPage: 0),
//                                                   imageURLs: widget.restaurant.restaurantImages!,
//                                                 ),
//                                               );
//                                             },
//                                             child: CachedNetworkImage(
//                                               imageUrl: widget.restaurant.restaurantImages![index],
//                                               fit: BoxFit.fill,
//                                             ),
//                                           );
//                                         }
//                                         // ? TODO: Add video player
//                                         return GestureDetector(
//                                           onTap: () async {
//                                             await showDialog(
//                                               context: context,
//                                               builder: (_) => ImageDialog(
//                                                 pageController: PageController(initialPage: 0),
//                                                 imageURLs: widget.restaurant.restaurantVideos!,
//                                               ),
//                                             );
//                                           },
//                                           child: VideoPlayer(
//                                             VideoPlayerController.networkUrl(
//                                               widget.restaurant.restaurantVideos![index -
//                                                   widget.restaurant.restaurantImages!.length],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }),
//                                   BlocBuilder<RestaurantReviewsBloc, RestaurantReviewsState>(
//                                     builder: (context, reviewState) {
//                                       if (reviewState is RestaurantReviewLoading) {
//                                         return Center(
//                                           child: LoadingAnimationWidget.dotsTriangle(
//                                             color: AppColors.primaryColor,
//                                             size: 64,
//                                           ),
//                                         );
//                                       } else if (reviewState is RestaurantReviewsError) {
//                                         return Center(
//                                           child: Column(
//                                             children: [
//                                               const Text("Error occured"),
//                                               verticalPadding(height: 2),
//                                               Text(reviewState.error),
//                                             ],
//                                           ),
//                                         );
//                                       } else if (reviewState is RestaurantReviewsLoaded) {
//                                         if (reviewState.results.reviews.isEmpty) {
//                                           return Center(
//                                               child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               SvgPicture.asset(
//                                                 "assets/images/no_camera_access.svg",
//                                                 height: 100,
//                                                 width: 100,
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               verticalPadding(height: 4),
//                                               const Text(
//                                                 "No reviews yet",
//                                                 style: TextStyle(
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                               verticalPadding(height: .5),
//                                               TextButton(
//                                                 style: ButtonStyle(
//                                                   overlayColor: MaterialStateProperty.all(
//                                                     AppColors.primaryColor.withOpacity(.1),
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   context.read<RestaurantReviewsBloc>().add(
//                                                         GetRestaurantReviewsEvent(
//                                                           restaurantId: widget.restaurant.id!,
//                                                         ),
//                                                       );
//                                                 },
//                                                 child: const Text("Refresh",
//                                                     style: TextStyle(
//                                                       color: AppColors.primaryColor,
//                                                     )),
//                                               ),
//                                             ],
//                                           ));
//                                         }
//                                         return ListView.builder(
//                                           itemCount: reviewState.results.reviews.length,
//                                           itemBuilder: (BuildContext context, int index) {
//
//                                             return RestaurantReviewsCard(
//                                               userReview: reviewState.results.reviews[index],
//                                             );
//                                           },
//                                         );
//                                       }
//                                       return ErrorDisplayWidget(
//                                         assetImage: "assets/images/error.png",
//                                         description: "Error occured",
//                                         errorMessage: "Error occured",
//                                         onPressed: () {
//                                           context.read<RestaurantReviewsBloc>().add(
//                                                 GetRestaurantReviewsEvent(
//                                                   restaurantId: widget.restaurant.id!,
//                                                 ),
//                                               );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 12,
//               left: 12,
//               right: 12,
//               child: CustomMainButton(
//                 title: AppLocalizations.of(context)!.visitText,
//                 onTap: () {
//                   context.pushNamed(
//                     AppRoutes.restaurantDetail,
//                     pathParameters: {'restaurantId': widget.restaurant.id!},
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTab(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 15,
//           color: AppColors.grey600,
//         ),
//       ),
//     );
//   }

//   _getOpeningHoursWidget(Restaurant restaurant, BuildContext context) {
//     // try {
//     DateFormat formatter = DateFormat('HH:mm:ss');
//     DateTime now = DateTime.now();
//     DateTime? openingTime = formatter.parse(restaurant.openingHour!);
//     DateTime? closingTime = formatter.parse(restaurant.closingHour!);

//     bool isOpen() {
//       if (openingTime == null || closingTime == null) return false;

//       // Get today's date at midnight to avoid date components interfering with the comparison
//       DateTime todayMidnight = DateTime(now.year, now.month, now.day);

//       // Add the parsed time components to today's date
//       openingTime =
//           todayMidnight.add(Duration(hours: openingTime!.hour, minutes: openingTime!.minute));
//       closingTime =
//           todayMidnight.add(Duration(hours: closingTime!.hour, minutes: closingTime!.minute));

//       return now.isAfter(openingTime!) && now.isBefore(closingTime!);
//     }

//     if (isOpen()) {
//       return Text(
//         AppLocalizations.of(context)!.openText,
//         style: const TextStyle(
//           fontSize: 12,
//           color: AppColors.successColor,
//           fontWeight: FontWeight.w400,
//         ),
//       );
//     } else {
//       return Text(
//         AppLocalizations.of(context)!.closedText,
//         style: const TextStyle(
//           fontSize: 10,
//           color: AppColors.failureColor,
//           fontWeight: FontWeight.w400,
//         ),
//       );
//     }
//   }

//   String formatPhoneNumber(String rawNumber) {
//     rawNumber = rawNumber.trim();
//     if (rawNumber.startsWith('251') && !rawNumber.startsWith('+')) {
//       return '+$rawNumber';
//     } else if (rawNumber.startsWith('0')) {
//       return '+251${rawNumber.substring(1)}';
//     } else if (rawNumber.startsWith('+251')) {
//       return rawNumber;
//     } else {
//       return '+251$rawNumber';
//     }
//   }

//   Future<void> makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await launchUrl(
//       Uri.parse(
//         launchUri.toString(),
//       ),
//     );
//   }
// }
