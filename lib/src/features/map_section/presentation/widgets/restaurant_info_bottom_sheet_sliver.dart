import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../../review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import '../../../review/presentation/widgets/restaurant_review_card.dart';
import '../../../user_profile/presentation/pages/custom_tab_bar.dart';
import '../../../user_profile/user_profile.dart';

class RestaurantInfoBottomSheet extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantInfoBottomSheet({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantInfoBottomSheet> createState() =>
      _RestaurantInfoBottomSheetState();
}

class _RestaurantInfoBottomSheetState extends State<RestaurantInfoBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<GetRestaurantReviewsBloc>().add(
        GetRestaurantReviewsRequestEvent(restaurantId: widget.restaurant.id!));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber = widget.restaurant.restaurantPhoneNumbers != null &&
            widget.restaurant.restaurantPhoneNumbers!.isNotEmpty
        ? formatPhoneNumber(
            widget.restaurant.restaurantPhoneNumbers![0].phoneNumber ?? '')
        : '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        onTap: () {},
        child: SafeArea(
          child: DraggableScrollableSheet(
            snap: false,
            expand: true,
            initialChildSize: .5,
            minChildSize: .5,
            maxChildSize: 1,
            snapSizes: const [.5, 1],
            builder:
                (BuildContext context, ScrollController scrollController) =>
                    SafeArea(
              child: Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      verticalPadding(height: 2),
                      Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      verticalPadding(height: 2),
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: CustomScrollView(
                                controller: scrollController,
                                physics: const RangeMaintainingScrollPhysics(),
                                slivers: [
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    pinned: true,
                                    collapsedHeight: 110,
                                    flexibleSpace: FlexibleSpaceBar(
                                      expandedTitleScale: 1,
                                      centerTitle: true,
                                      background:
                                          Container(color: Colors.white),
                                      title: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            verticalPadding(height: 2),
                                            Text(
                                              widget.restaurant.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.textDark,
                                                height: 1.2,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            verticalPadding(height: 1),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: AppColors.primaryColor,
                                                ),
                                                horizontalPadding(width: .2),
                                                Text(
                                                  "${widget.restaurant.averageRating}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.grey700,
                                                  ),
                                                ),
                                                horizontalPadding(width: .5),
                                                Text(
                                                  "(${widget.restaurant.numberOfReviews} ${AppLocalizations.of(context)!.revText})",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            verticalPadding(height: .2),
                                            // Walking Distance display
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.directions_walk_rounded,
                                                  color: AppColors.grey400,
                                                  size: 16,
                                                ),
                                                horizontalPadding(width: .4),
                                                Text(
                                                  "${widget.restaurant.walkingTime} ${AppLocalizations.of(context)!.walkingDistanceText}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 18),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              verticalPadding(height: 2),
                                              RestaurantServiceCard(
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .userReviewText,
                                                info:
                                                    "${widget.restaurant.numberOfReviews} ${AppLocalizations.of(context)!.revText}",
                                                iconPath:
                                                    "assets/icons/star.svg",
                                                onTap: () {
                                                  context.pushNamed(
                                                    AppRoutes.restaurantMenu,
                                                    extra: widget.restaurant,
                                                  );
                                                },
                                              ),
                                              RestaurantServiceCard(
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .openingHrText,
                                                iconPath:
                                                    "assets/icons/clock_circle.svg",
                                                leftWidget:
                                                    _getOpeningHoursWidget(
                                                        widget.restaurant,
                                                        context),
                                                info: "",
                                              ),
                                              widget.restaurant
                                                              .restaurantPhoneNumbers !=
                                                          null &&
                                                      widget
                                                          .restaurant
                                                          .restaurantPhoneNumbers!
                                                          .isNotEmpty
                                                  ? RestaurantServiceCard(
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .callText,
                                                      info: phoneNumber,
                                                      showDivider: false,
                                                      iconPath:
                                                          "assets/icons/call.svg",
                                                      onTap: () async {
                                                        await makePhoneCall(
                                                            phoneNumber);
                                                      },
                                                    )
                                                  : Container(),
                                              RestaurantServiceCard(
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .seeMapText,
                                                iconPath:
                                                    "assets/icons/navigate.svg",
                                                info: AppLocalizations.of(
                                                        context)!
                                                    .navText,
                                                onTap: () {
                                                  var userLocationState = context
                                                      .read<UserLocationBloc>()
                                                      .state;
                                                  if (userLocationState
                                                      is UserLocationLoaded) {
                                                    _launchDirections(
                                                      startPoint:
                                                          userLocationState
                                                              .location,
                                                      destinationPoint:
                                                          Location(
                                                        latitude: widget
                                                            .restaurant
                                                            .restaurantLocations!
                                                            .first
                                                            .latitude!,
                                                        longitude: widget
                                                            .restaurant
                                                            .restaurantLocations!
                                                            .first
                                                            .longitude!,
                                                      ),
                                                    );
                                                  } else {
                                                    showCustomToast(
                                                      context: context,
                                                      toastMessage:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .failedLocationText,
                                                      toastType:
                                                          ToastType.warning,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverAppBar(
                                    primary: true,
                                    pinned: true,
                                    toolbarHeight: 60,
                                    automaticallyImplyLeading: false,
                                    flexibleSpace: CustomTabBar(
                                      height: 60,
                                      tabBar: TabBar(
                                        controller: _tabController,
                                        indicatorPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 12),
                                        dividerColor: Colors.transparent,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: elevation_2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        tabs: [
                                          _buildTab(
                                              AppLocalizations.of(context)!
                                                  .imagesText),
                                          _buildTab(
                                              AppLocalizations.of(context)!
                                                  .userReviewText),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverFillRemaining(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            // Filter out empty URLs from images and videos
                                            final validImages = widget
                                                    .restaurant.restaurantImages
                                                    ?.where((img) =>
                                                        img.url.isNotEmpty)
                                                    .toList() ??
                                                [];

                                            final validVideos = widget
                                                    .restaurant.restaurantVideos
                                                    ?.where((vid) =>
                                                        vid.url.isNotEmpty)
                                                    .toList() ??
                                                [];

                                            final totalMediaCount =
                                                validImages.length +
                                                    validVideos.length;

                                            if (totalMediaCount == 0) {
                                              return SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 30.h),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: AppColors
                                                                .grey200,
                                                            boxShadow:
                                                                elevation_4,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/no_camera_access.svg",
                                                              height: 100,
                                                              width: 100,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        verticalPadding(
                                                            height: 3),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .noImagesRestaurantText,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            return MasonryGridView.count(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              controller: scrollController,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: totalMediaCount,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          ImageDialog(
                                                        pageController:
                                                            PageController(
                                                                initialPage:
                                                                    index),
                                                        imageURLs: validImages.cast<
                                                            ReviewMediaModel>(),
                                                        mediaList: validVideos,
                                                      ),
                                                    );
                                                  },
                                                  child: (index <
                                                          validImages.length)
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              validImages[index]
                                                                  .url,
                                                          memCacheHeight: (9.h)
                                                              .cacheSize(
                                                                  context),
                                                          fit: BoxFit.fill,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error,
                                                                  color: AppColors
                                                                      .grey400),
                                                        )
                                                      : VideoPlayer(
                                                          VideoPlayerController
                                                              .networkUrl(
                                                            Uri.parse(
                                                              validVideos[index -
                                                                      validImages
                                                                          .length]
                                                                  .url,
                                                            ),
                                                          ),
                                                        ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        BlocBuilder<GetRestaurantReviewsBloc,
                                            GetRestaurantReviewsState>(
                                          builder: (context, reviewState) {
                                            if (reviewState
                                                is GetRestaurantReviewsLoading) {
                                              return Center(
                                                child: LoadingAnimationWidget
                                                    .dotsTriangle(
                                                  color: AppColors.primaryColor,
                                                  size: 64,
                                                ),
                                              );
                                            } else if (reviewState
                                                is GetRestaurantReviewsFailure) {
                                              return Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .errorOccurredText,
                                                    ),
                                                    verticalPadding(height: 2),
                                                    Text(reviewState.message),
                                                  ],
                                                ),
                                              );
                                            } else if (reviewState
                                                is GetRestaurantReviewsLoaded) {
                                              if (reviewState
                                                  .reviews.reviews.isEmpty) {
                                                return SingleChildScrollView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxHeight: 30.h),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/no_camera_access.svg",
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          verticalPadding(
                                                              height: 4),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .noReviewsText,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          verticalPadding(
                                                              height: .5),
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              overlayColor:
                                                                  WidgetStateProperty
                                                                      .all(
                                                                AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .1),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      GetRestaurantReviewsBloc>()
                                                                  .add(
                                                                    GetRestaurantReviewsRequestEvent(
                                                                      restaurantId: widget
                                                                          .restaurant
                                                                          .id!,
                                                                    ),
                                                                  );
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .refreshText,
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return ListView.builder(
                                                itemCount: reviewState
                                                    .reviews.reviews.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return RestaurantReviewsCard(
                                                    restaurant:
                                                        widget.restaurant,
                                                    userReview: reviewState
                                                        .reviews.reviews[index],
                                                  );
                                                },
                                              );
                                            }
                                            return ErrorAndInfoDisplayWidget(
                                              assetImage:
                                                  "assets/images/error.png",
                                              description: "Error occured",
                                              title: "Error occured",
                                              onPressed: () {
                                                context
                                                    .read<
                                                        GetRestaurantReviewsBloc>()
                                                    .add(
                                                      GetRestaurantReviewsRequestEvent(
                                                        restaurantId: widget
                                                            .restaurant.id!,
                                                      ),
                                                    );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: CustomMainButton(
                                title: AppLocalizations.of(context)!.visitText,
                                onTap: () {
                                  context.pushNamed(
                                    AppRoutes.restaurantDetail,
                                    pathParameters: {
                                      'restaurantId': widget.restaurant.id!
                                    },
                                  );
                                },
                              ),
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
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Future<void> _launchDirections({
    required Location startPoint,
    required Location destinationPoint,
  }) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${startPoint.latitude},${startPoint.longitude}&destination=${destinationPoint.latitude},${destinationPoint.longitude}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _getOpeningHoursWidget(Restaurant restaurant, BuildContext context) {
    // try {
    DateFormat formatter = DateFormat('HH:mm:ss');
    DateTime now = DateTime.now();
    DateTime? openingTime = restaurant.openingHour != null
        ? formatter.parse(restaurant.openingHour!)
        : null;
    DateTime? closingTime = restaurant.closingHour != null
        ? formatter.parse(restaurant.closingHour!)
        : null;

    bool isOpen() {
      if (openingTime == null || closingTime == null) return false;

      // Get today's date at midnight to avoid date components interfering with the comparison
      DateTime todayMidnight = DateTime(now.year, now.month, now.day);

      // Add the parsed time components to today's date
      openingTime = todayMidnight.add(
          Duration(hours: openingTime!.hour, minutes: openingTime!.minute));
      closingTime = todayMidnight.add(
          Duration(hours: closingTime!.hour, minutes: closingTime!.minute));

      return now.isAfter(openingTime!) && now.isBefore(closingTime!);
    }

    if (isOpen()) {
      return Text(
        AppLocalizations.of(context)!.openText,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.successColor,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.closedText,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.failureColor,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  String formatPhoneNumber(String rawNumber) {
    rawNumber = rawNumber.trim();
    if (rawNumber.startsWith('251') && !rawNumber.startsWith('+')) {
      return '+$rawNumber';
    } else if (rawNumber.startsWith('0')) {
      return '+251${rawNumber.substring(1)}';
    } else if (rawNumber.startsWith('+251')) {
      return rawNumber;
    } else {
      return '+251$rawNumber';
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(
      Uri.parse(
        launchUri.toString(),
      ),
    );
  }
}
