import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/utils/proper_user_name.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_state.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/get_others_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_user_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_recommendation/other_recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_recommendation/other_recommendation_state.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/recommendation_card.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_recommendation_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../presentation.dart';
import '../widgets/shimmer/user_review_shimmer.dart';

class OthersProfilePage extends StatefulWidget {
  final String userId;
  const OthersProfilePage({super.key, required this.userId});

  @override
  State<OthersProfilePage> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ScrollController _recommendationController;
  late final ScrollController _reviewController;
  int followerCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _recommendationController = ScrollController();
    _recommendationController.addListener(_recommendationOnScroll);
    _reviewController = ScrollController();
    _reviewController.addListener(_reviewOnScroll);
  }

  @override
  void dispose() {
    _recommendationController
      ..removeListener(_recommendationOnScroll)
      ..dispose();
    _reviewController
      ..removeListener(_reviewOnScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => dpLocator<GetOthersProfileBloc>()
            ..add(
              GetOthersProfileEvent(
                userId: widget.userId,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => dpLocator<FollowBloc>(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: 100.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: BlocConsumer<GetOthersProfileBloc, GetOthersProfileState>(
                listener: (context, state) {
                  // context.read<OthersFavoriteBloc>().add(
                  //       GetOthersFavoritesEvent(
                  //         userId: widget.userId,
                  //       ),
                  //     );
                  context.read<OthersReviewBloc>().add(
                        GetOthersReviewEvent(
                          userId: widget.userId,
                          page: 1,
                          reviews: const [],
                        ),
                      );
                  context.read<OtherRecommendationBloc>().add(
                        GetOtherRecommendation(
                          id: widget.userId,
                          page: 1,
                          recommendations: [],
                        ),
                      );
                  setState(() {
                    if (state is OthersProfileLoaded) {
                      followerCount = state.user.userStat != null
                          ? (state.user.userStat!.followers ?? 0)
                          : 0;
                    }
                  });
                },
                builder: (context, profileState) {
                  if (profileState is OthersProfileLoading) {
                    return SizedBox(
                      height: screenHeight,
                      width: screenWidth,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.dotsTriangle(
                              color: AppColors.primaryColor,
                              size: screenHeight * 0.058,
                            ),
                            verticalPadding(height: 1),
                            Text(
                              AppLocalizations.of(context)!.loadingProfileText,
                              style: subTitleTextStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (profileState is OthersProfileLoaded) {
                    return DefaultTabController(
                      length: 2,
                      child: NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          setState(() {});
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<GetOthersProfileBloc>().add(
                                GetOthersProfileEvent(userId: widget.userId));

                            context.read<OthersReviewBloc>().add(
                                  GetOthersReviewEvent(
                                    userId: widget.userId,
                                    page: 1,
                                    reviews: const [],
                                  ),
                                );
                            context
                                .read<OtherRecommendationBloc>()
                                .add(GetOtherRecommendation(
                                  id: widget.userId,
                                  page: 1,
                                  recommendations: [],
                                ));
                          },
                          color: Colors.red,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomAppBar(
                                  onTap: context.pop,
                                  title: getProperUserName(
                                    firstName: profileState.user.firstName,
                                    lastName: profileState.user.lastName,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 14.h,
                                      width: 14.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: GestureDetector(
                                          onTap:
                                              profileState.user.image == null ||
                                                      profileState
                                                          .user.image!.isEmpty
                                                  ? null
                                                  : () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => Dialog(
                                                          backgroundColor:
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.8),
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero,
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              SizedBox(
                                                                child:
                                                                    PhotoView(
                                                                  imageProvider:
                                                                      CachedNetworkImageProvider(profileState
                                                                          .user
                                                                          .image!),
                                                                  backgroundDecoration:
                                                                      const BoxDecoration(
                                                                          color:
                                                                              Colors.transparent),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  top: 4.h,
                                                                  right: 3.w,
                                                                  child:
                                                                      Container(
                                                                    height: 5.h,
                                                                    width: 5.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              .5),
                                                                      boxShadow: [
                                                                        ...elevation_4
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .pop();
                                                                      },
                                                                      icon: SvgPicture
                                                                          .asset(
                                                                        'assets/icons/x.svg',
                                                                        colorFilter:
                                                                            const ColorFilter.mode(
                                                                          Colors
                                                                              .black,
                                                                          BlendMode
                                                                              .srcIn,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                          child: CachedNetworkImage(
                                            imageUrl: profileState.user.image!,
                                            memCacheHeight:
                                                (screenHeight * 0.12).cacheSize(
                                              context,
                                            ),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.person,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: SizedBox(
                                        height: 16.h,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Tooltip(
                                                    preferBelow: false,
                                                    showDuration:
                                                        const Duration(
                                                      seconds: 5,
                                                    ),
                                                    triggerMode:
                                                        TooltipTriggerMode.tap,
                                                    message:
                                                        "Get contributions by giving reviews get extra contributions by adding more images and videos",
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          profileState.user
                                                                      .userStat !=
                                                                  null
                                                              ? formatNumber(
                                                                  profileState
                                                                      .user
                                                                      .userStat!
                                                                      .contributions!
                                                                      .toDouble())
                                                              : "NA",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .contributionsText,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .grey600,
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.pushNamed(
                                                          AppRoutes
                                                              .followingPage,
                                                          pathParameters: {
                                                            "userId":
                                                                profileState
                                                                    .user.id!
                                                          },
                                                          queryParameters: {
                                                            "tab": "followers"
                                                          },
                                                          extra: getProperUserName(
                                                              firstName:
                                                                  profileState
                                                                      .user
                                                                      .firstName,
                                                              lastName:
                                                                  profileState
                                                                      .user
                                                                      .lastName));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          profileState.user
                                                                      .userStat !=
                                                                  null
                                                              ? followerCount
                                                                  .toString()
                                                              : "NA",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .followersText,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .grey600,
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.pushNamed(
                                                          AppRoutes
                                                              .followingPage,
                                                          pathParameters: {
                                                            "userId":
                                                                profileState
                                                                    .user.id!
                                                          },
                                                          queryParameters: {
                                                            "tab": "following"
                                                          },
                                                          extra: getProperUserName(
                                                              firstName:
                                                                  profileState
                                                                      .user
                                                                      .firstName,
                                                              lastName:
                                                                  profileState
                                                                      .user
                                                                      .lastName));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          profileState.user
                                                                      .userStat !=
                                                                  null
                                                              ? profileState
                                                                  .user
                                                                  .userStat!
                                                                  .following
                                                                  .toString()
                                                              : "NA",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .followingText,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .grey600,
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: 5.h,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      child: BlocConsumer<
                                                              FollowBloc,
                                                              FollowState>(
                                                          listener: (context,
                                                              followState) {
                                                        if (followState
                                                            is FollowUserFailed) {
                                                          showCustomToast(
                                                              toastType:
                                                                  ToastType
                                                                      .error,
                                                              toastMessage:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .failedToFollowText,
                                                              context: context);
                                                        } else if (followState
                                                            is UnfollowUserFailed) {
                                                          showCustomToast(
                                                              context: context,
                                                              toastMessage:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .failedToUnfollowText,
                                                              toastType:
                                                                  ToastType
                                                                      .error);
                                                        }
                                                        if (followState
                                                            is FollowUserSuccess) {
                                                          setState(() {
                                                            followerCount += 1;
                                                          });
                                                        } else if (followState
                                                            is UnfollowUserSuccess) {
                                                          setState(() {
                                                            followerCount -= 1;
                                                          });
                                                        }
                                                      }, builder: (context,
                                                              followState) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            final currUser = dpLocator<
                                                                    AuthenticationLocalSource>()
                                                                .getUserCredential();
                                                            if (currUser !=
                                                                null) {
                                                              followButtonOnTap(
                                                                  context,
                                                                  followState,
                                                                  profileState);
                                                            } else {
                                                              _showLoginDialog(
                                                                  context,
                                                                  userId:
                                                                      profileState
                                                                          .user
                                                                          .id!);
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 6.h,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: 0.2.h,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .profilePointsBackgroundColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                20,
                                                              ),
                                                            ),
                                                            child: (followState
                                                                        is FollowUserLoading ||
                                                                    followState
                                                                        is UnfollowUserLoading)
                                                                ? Center(
                                                                    child: Text(
                                                                      getFollowText(
                                                                          context,
                                                                          followState,
                                                                          profileState),
                                                                      style:
                                                                          const TextStyle(
                                                                        color: AppColors
                                                                            .grey400,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child: Text(
                                                                      getFollowText(
                                                                          context,
                                                                          followState,
                                                                          profileState),
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (true
                                                              // to be added when message feature is added only people above level 5
                                                              // ||
                                                              //     profileState.user
                                                              //             .levelInfo ==
                                                              //         null ||
                                                              //     profileState
                                                              //             .user
                                                              //             .levelInfo!
                                                              //             .level ==
                                                              //         null ||
                                                              //     profileState
                                                              //             .user
                                                              //             .levelInfo!
                                                              //             .level! <
                                                              //         5
                                                              ) {
                                                            showCustomToast(
                                                                context:
                                                                    context,
                                                                toastType:
                                                                    ToastType
                                                                        .info,
                                                                toastMessage:
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .messageFeatureCommingSoonText);
                                                          }
                                                          // else {
                                                          //   // do some thing here when message button is clicked
                                                          // }
                                                        },
                                                        child: Container(
                                                          height: 6.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 0.2.h,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .profilePointsBackgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              20,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .messageText,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      getProperUserName(
                                        firstName: profileState.user.firstName,
                                        lastName: profileState.user.lastName,
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 3.h,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    profileState.user.verified == 1 ||
                                            profileState.user.verified == 2
                                        ? Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            preferBelow: false,
                                            message:
                                                AppLocalizations.of(context)!
                                                    .howToGetVerifiedText,
                                            waitDuration:
                                                const Duration(seconds: 5),
                                            child: const Icon(
                                              Icons.verified,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      profileState.user.levelInfo != null
                                          ? "${AppLocalizations.of(context)!.level} ${profileState.user.levelInfo!.level}"
                                          : "NA",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1.h),
                                      height: 0.5.h,
                                      width: 0.5.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.grey300,
                                      ),
                                    ),
                                    Text(
                                      profileState.user.levelInfo != null
                                          ? (profileState.user.levelInfo!
                                                      .levelName !=
                                                  null
                                              ? profileState
                                                  .user.levelInfo!.levelName!
                                              : AppLocalizations.of(context)!
                                                  .noLevel)
                                          : "NA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17.sp,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                const Divider(
                                  color: AppColors.dividerColor,
                                ),
                                CustomTabBar(
                                  height: 30.sp,
                                  tabBar: TabBar(
                                    controller: _tabController,
                                    tabAlignment: TabAlignment.center,
                                    labelColor: Colors.red,
                                    labelStyle:
                                        const TextStyle(color: Colors.red),
                                    dividerColor: Colors.transparent,
                                    indicator: const BoxDecoration(),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    tabs: [
                                      _buildTab(
                                          title: AppLocalizations.of(context)!
                                              .revText
                                              .toUpperCase(),
                                          iconData: Iconsax.activity,
                                          count:
                                              profileState.user.userStat != null
                                                  ? profileState.user.userStat!
                                                      .reviewsCount!
                                                  : 0,
                                          isActive: _tabController.index == 0),
                                      _buildTab(
                                          title: AppLocalizations.of(context)!
                                              .recommendations
                                              .toUpperCase(),
                                          iconData:
                                              Icons.favorite_border_rounded,
                                          count:
                                              profileState.user.userStat != null
                                                  ? profileState.user.userStat!
                                                      .recommendations!
                                                  : 0,
                                          isActive: _tabController.index == 1),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        BlocBuilder<OthersReviewBloc,
                                            OthersReviewState>(
                                          builder: (context, userReviewState) {
                                            if (userReviewState
                                                is OthersReviewLoaded) {
                                              var userReviews =
                                                  userReviewState.userReviews;
                                              if (userReviews.isEmpty) {
                                                return ErrorAndInfoDisplayWidget(
                                                  assetImage:
                                                      "assets/icons/no_content.svg",
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .profileNoReviewsText,
                                                  description: AppLocalizations
                                                          .of(context)!
                                                      .profileNoReviewsText1,
                                                  onPressed: null,
                                                );
                                              }

                                              return SingleChildScrollView(
                                                controller: _reviewController,
                                                child: Column(
                                                  children: [
                                                    ...List.generate(
                                                      userReviews.length,
                                                      (index) => UserReviewCard(
                                                        userReview:
                                                            userReviews[index],
                                                      ),
                                                    ),
                                                    userReviewState
                                                            .hasReachedMax
                                                        ? Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .noMoreReviews,
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .grey600,
                                                            ),
                                                          )
                                                        : const SizedBox(
                                                            height: 0,
                                                          ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (userReviewState
                                                is OthersReviewLoading) {
                                              return const UserReviewShimmerDisplay();
                                            } else if (userReviewState
                                                is OthersReviewError) {
                                              return ErrorAndInfoDisplayWidget(
                                                assetImage:
                                                    "assets/icons/no_internet_1.svg",
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .unknownErrorText,
                                                description:
                                                    AppLocalizations.of(
                                                            context)!
                                                        .tryAgainText,
                                                onPressed: () {
                                                  context
                                                      .read<OthersReviewBloc>()
                                                      .add(
                                                        GetOthersReviewEvent(
                                                          userId: widget.userId,
                                                          page: 1,
                                                          reviews: const [],
                                                        ),
                                                      );
                                                },
                                              );
                                            } else if (userReviewState
                                                is OthersReviewNextLoading) {
                                              return SingleChildScrollView(
                                                controller: _reviewController,
                                                child: Column(
                                                  children: [
                                                    ...List.generate(
                                                      userReviewState
                                                          .userReviews.length,
                                                      (index) => UserReviewCard(
                                                        userReview:
                                                            userReviewState
                                                                    .userReviews[
                                                                index],
                                                      ),
                                                    ),
                                                    const UserReviewShimmerDisplay(
                                                      shimmerCount: 1,
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        BlocBuilder<OtherRecommendationBloc,
                                                OtherRecommendationState>(
                                            builder: (context, state) {
                                          if (state
                                              is OtherRecommendationSuccess) {
                                            if (state.recommendations.isEmpty) {
                                              return ErrorAndInfoDisplayWidget(
                                                assetImage:
                                                    "assets/icons/no_content.svg",
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .noRecommendationFound,
                                                description:
                                                    AppLocalizations.of(
                                                            context)!
                                                        .othersnoFavText,
                                                onPressed: null,
                                              );
                                            }
                                            return SingleChildScrollView(
                                              controller:
                                                  _recommendationController,
                                              child: Column(
                                                children: [
                                                  ...List.generate(
                                                    state
                                                        .recommendations.length,
                                                    (index) {
                                                      return RecommendationCard(
                                                        userRecommendation:
                                                            state.recommendations[
                                                                index],
                                                      );
                                                    },
                                                  ),
                                                  state.hasReachedMax
                                                      ? Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .noMoreRecommendations,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .grey600,
                                                          ),
                                                        )
                                                      : const SizedBox(
                                                          height: 0,
                                                        ),
                                                  SizedBox(
                                                    height: 7.h,
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (state
                                              is OtherRecommendationLoading) {
                                            return const UserRecommendationItemsShimmer();
                                          } else if (state
                                              is OtherRecommendationNextLoading) {
                                            return SingleChildScrollView(
                                              controller:
                                                  _recommendationController,
                                              child: Column(
                                                children: [
                                                  ...List.generate(
                                                    state
                                                        .recommendations.length,
                                                    (index) {
                                                      return RecommendationCard(
                                                          userRecommendation:
                                                              state.recommendations[
                                                                  index]);
                                                    },
                                                  ),
                                                  const UserRecommendationItemsShimmer(
                                                    shimmerCount: 1,
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return ErrorAndInfoDisplayWidget(
                                              assetImage:
                                                  "assets/icons/no_internet_1.svg",
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .unknownErrorText,
                                              description:
                                                  AppLocalizations.of(context)!
                                                      .tryAgainText,
                                              onPressed: () {
                                                context
                                                    .read<
                                                        OtherRecommendationBloc>()
                                                    .add(
                                                      GetOtherRecommendation(
                                                        id: widget.userId,
                                                        recommendations: [],
                                                        page: 1,
                                                      ),
                                                    );
                                              },
                                            );
                                          }
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (profileState is GetOthersProfileError) {
                    return ErrorAndInfoDisplayWidget(
                        assetImage: "assets/icons/no_internet_1.svg",
                        title: AppLocalizations.of(context)!.tryAgainText,
                        description: profileState.error,
                        onPressed: () {
                          context.read<GetOthersProfileBloc>().add(
                                GetOthersProfileEvent(
                                  userId: widget.userId,
                                ),
                              );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatNumber(double number) {
    if (number >= 1000) {
      double roundedNumber = number / 1000;
      String formattedNumber = roundedNumber.toStringAsFixed(
          roundedNumber.truncateToDouble() == roundedNumber ? 0 : 1);
      return '${formattedNumber}k';
    } else {
      return number.toInt().toString();
    }
  }

  Column getSubProfileInfo({
    required String value,
    required String title,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _recommendationOnScroll() {
    final state = context.read<OtherRecommendationBloc>().state;
    if (state is OtherRecommendationSuccess && !state.hasReachedMax) {
      if (_recommendationController.position.pixels ==
          _recommendationController.position.maxScrollExtent) {
        context.read<OtherRecommendationBloc>().add(GetOtherRecommendation(
            id: widget.userId,
            page: state.page + 1,
            recommendations: state.recommendations));
      }
    }
  }

  void _reviewOnScroll() {
    final state = context.read<OthersReviewBloc>().state;
    if (state is OthersReviewLoaded && !state.hasReachedMax) {
      if (_reviewController.position.pixels ==
          _reviewController.position.maxScrollExtent) {
        context.read<OthersReviewBloc>().add(
              GetOthersReviewEvent(
                page: state.page + 1,
                userId: widget.userId,
                reviews: state.userReviews,
              ),
            );
      }
    }
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  final double height;

  const CustomTabBar({super.key, required this.tabBar, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.sp),
          topRight: Radius.circular(12.sp),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

String getFollowText(context, followState, profileState) {
  if (followState is FollowUserInitial) {
    if (profileState.user.isFollowed == null ||
        !profileState.user.isFollowed!) {
      return AppLocalizations.of(context)!.follow;
    } else {
      return AppLocalizations.of(context)!.followingText;
    }
  } else if (followState is FollowUserSuccess ||
      followState is UnfollowUserFailed ||
      followState is UnfollowUserLoading) {
    return AppLocalizations.of(context)!.followingText;
  }
  return AppLocalizations.of(context)!.follow;
}

void followButtonOnTap(context, FollowState followState, profileState) {
  final currUser = dpLocator<AuthenticationLocalSource>().getUserCredential();
  if (profileState.user.id == currUser!.id) {
    showCustomToast(
        context: context,
        toastMessage: AppLocalizations.of(context)!.cannotFollowYourselfText,
        toastType: ToastType.warning);
    return;
  }
  if (followState is FollowUserInitial) {
    if (profileState.user.isFollowed == null ||
        !profileState.user.isFollowed!) {
      BlocProvider.of<FollowBloc>(context)
          .add(FollowUserEvent(userId: profileState.user.id!));
    } else {
      BlocProvider.of<FollowBloc>(context)
          .add(UnfollowUserEvent(userId: profileState.user.id!));
    }
  } else if (followState is FollowUserSuccess ||
      followState is UnfollowUserFailed) {
    BlocProvider.of<FollowBloc>(context)
        .add(UnfollowUserEvent(userId: profileState.user.id!));
  } else if (followState is UnfollowUserLoading ||
      followState is FollowUserLoading) {
  } else {
    BlocProvider.of<FollowBloc>(context)
        .add(FollowUserEvent(userId: profileState.user.id!));
  }
}

Widget _buildTab(
    {required String title,
    required IconData iconData,
    int count = 0,
    required bool isActive}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.sp),
    child: Row(
      children: [
        isActive
            ? Icon(
                iconData,
                color: Colors.red,
                size: 16.sp,
              )
            : const SizedBox(),
        isActive
            ? SizedBox(
                width: 1.w,
              )
            : const SizedBox(),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: isActive ? Colors.red : AppColors.grey600,
          ),
        ),
        !isActive
            ? SizedBox(
                width: 1.w,
              )
            : const SizedBox(),
        !isActive
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 5.w,
                height: 3.5.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              )
            : const SizedBox()
      ],
    ),
  );
}

void _showLoginDialog(
  BuildContext context, {
  required String userId,
}) {
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
                'routeName': AppRoutes.othersProfilePage,
                'userId': userId,
              };
              Navigator.of(ctx).pop(); // Close the dialog
              context.pushNamed(
                AppRoutes.login,
                extra: routeInfo,
              ); // Navigate to login screen
            },
            child: Text(AppLocalizations.of(context)!.loginText),
          ),
        ],
      );
    },
  );
}
