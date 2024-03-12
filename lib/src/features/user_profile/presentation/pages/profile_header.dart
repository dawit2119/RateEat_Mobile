import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/recommendation/recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/proper_user_name.dart';
import '../../../authentication/authentication.dart';
import 'pages.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with TickerProviderStateMixin {
  // late final GifController _gifController;

  @override
  void initState() {
    super.initState();
    // _gifController = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    return BlocConsumer<GetUserProfileBloc, GetUserProfileState>(
      listener: (context, state) {
        context.read<UserFavoriteBloc>().add(
              GetUserFavoritesEvent(
                userId: user!.id!,
              ),
            );
        context.read<UserReviewBloc>().add(
              GetUserReviewEvent(
                userId: user.id!,
                page: 1,
              ),
            );
        context.read<SavedReviewsBloc>().add(GetSavedReviewsEvent());
        context
            .read<RecommendationBloc>()
            .add(GetMyRecommendations(page: 1, recommendations: []));
      },
      builder: (context, profileState) {
        if (profileState is UserProfileLoading) {}
        if (profileState is UserProfileLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 10.h,
                    width: 10.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: GestureDetector(
                        onTap: _isValidImageUrl(profileState.user.image)
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    insetPadding: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          child: (profileState.user.image ?? "")
                                                  .isNotEmpty
                                              ? PhotoView(
                                                  imageProvider:
                                                      CachedNetworkImageProvider(
                                                          profileState
                                                              .user.image!),
                                                  backgroundDecoration:
                                                      const BoxDecoration(
                                                          color: Colors
                                                              .transparent),
                                                )
                                              : Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 100,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ),
                                        Positioned(
                                            top: 4.h,
                                            right: 3.w,
                                            child: Container(
                                              height: 5.h,
                                              width: 5.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white
                                                    .withOpacity(.5),
                                                boxShadow: [...elevation_4],
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                                icon: SvgPicture.asset(
                                                  'assets/icons/x.svg',
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                    Colors.black,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: _isValidImageUrl(profileState.user.image)
                            ? CachedNetworkImage(
                                imageUrl: profileState.user.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.person,
                                ),
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Tooltip(
                                preferBelow: false,
                                showDuration: const Duration(
                                  seconds: 5,
                                ),
                                triggerMode: TooltipTriggerMode.tap,
                                message:
                                    "Get contributions by giving reviews get extra contributions by adding more images and videos",
                                child: Column(
                                  children: [
                                    Text(
                                      profileState.user.userStat
                                                  ?.contributions !=
                                              null
                                          ? formatNumber(profileState
                                              .user.userStat!.contributions!
                                              .toDouble())
                                          : "NA",
                                      style: semiBold18,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .contributionsText,
                                      style: regular14.copyWith(
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(AppRoutes.followingPage,
                                      pathParameters: {"userId": user!.id!},
                                      queryParameters: {"tab": "followers"},
                                      extra: getProperUserName(
                                          firstName: user.firstName,
                                          lastName: user.lastName));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      profileState.user.userStat != null
                                          ? profileState
                                              .user.userStat!.followers
                                              .toString()
                                          : "NA",
                                      style: semiBold18,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .followersText,
                                      style: regular14.copyWith(
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(AppRoutes.followingPage,
                                      pathParameters: {"userId": user!.id!},
                                      queryParameters: {"tab": "following"},
                                      extra: getProperUserName(
                                          firstName: user.firstName,
                                          lastName: user.lastName));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      profileState.user.userStat != null
                                          ? profileState
                                              .user.userStat!.following
                                              .toString()
                                          : "NA",
                                      style: semiBold18,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .followingText,
                                      style: regular14.copyWith(
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalPadding(height: 1.4),
                        Container(
                          height: 5.8.h, // ~46px responsive
                          decoration: BoxDecoration(
                            color: AppColors.profilePointsBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(1.h), // ~8px responsive
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.sp,
                            horizontal: 4.sp,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Tooltip(
                                preferBelow: false,
                                showDuration: const Duration(seconds: 5),
                                triggerMode: TooltipTriggerMode.tap,
                                message:
                                    "Be among the first three reviewers of an item or restaurant to earn points(bytecoins).",
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Iconsax.ranking5,
                                      size: 2.4.h, // responsive icon size
                                      color:
                                          AppColors.pointsIconBackgroundColor,
                                    ),
                                    SizedBox(width: 0.4.h), // ~3px responsive
                                    Text(
                                      formatNumber(profileState.user.incentive!
                                              .totalIncentivized! +
                                          profileState.user.incentive!
                                              .pendingIncentive!),
                                      style: semiBold16,
                                    ),
                                    horizontalPadding(width: 0.4.w),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .pointsText
                                          .toLowerCase(),
                                      style: regular16.copyWith(
                                          color: AppColors.grey600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 0.25.h, // ~2px responsive
                                decoration: BoxDecoration(
                                  color: AppColors.textWhite,
                                  borderRadius: BorderRadius.circular(0.5.h),
                                ),
                              ),
                              (profileState.user.incentive != null)
                                  ? GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LeaderBoardBloc>()
                                            .add(GetLeaderBoardEvent(page: 1));
                                        context.pushNamed(
                                            AppRoutes.leaderBoardPage);
                                      },
                                      child: (profileState
                                                  .user.incentive!.weeklyRank !=
                                              null
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Iconsax.ranking_15,
                                                  size: 2.4.h,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 0.4.h),
                                                Text(
                                                  "${profileState.user.incentive!.weeklyRank!}${getPrefix(profileState.user.incentive!.weeklyRank!)}",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey600,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 0.4.h),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .weeklySmallText,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey600,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Tooltip(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .notRankedTooltipText,
                                              triggerMode:
                                                  TooltipTriggerMode.longPress,
                                              preferBelow: false,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Iconsax.ranking_15,
                                                    size: 2.4.h,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .notRankedText,
                                                    maxLines: 1,
                                                    style: regular16.copyWith(
                                                        color:
                                                            AppColors.grey600),
                                                  ),
                                                ],
                                              ),
                                            )),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LeaderBoardBloc>()
                                            .add(GetLeaderBoardEvent(page: 1));
                                        context.pushNamed(
                                            AppRoutes.leaderBoardPage);
                                      },
                                      child: Tooltip(
                                        message: AppLocalizations.of(context)!
                                            .failedToGetWeeklyRankText,
                                        triggerMode:
                                            TooltipTriggerMode.longPress,
                                        preferBelow: false,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Iconsax.ranking_15,
                                              size: 2.4.h,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "NA",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              verticalPadding(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getProperUserName(
                              firstName: profileState.user.firstName,
                              lastName: profileState.user.lastName,
                            ),
                            style: semiBold18,
                          ),
                          // const SizedBox(
                          //   width: 3,
                          // ),
                          // profileState.user.verified == 1 ||
                          //         profileState.user.verified == 2
                          //     ? Tooltip(
                          //         triggerMode: TooltipTriggerMode.tap,
                          //         preferBelow: false,
                          //         message: AppLocalizations.of(context)!
                          //             .howToGetVerifiedText,
                          //         waitDuration: const Duration(seconds: 5),
                          //         child: const Icon(
                          //           Icons.verified,
                          //           color: Colors.blue,
                          //           size: 20,
                          //         ),
                          //       )
                          //     : Container(),
                        ],
                      ),
                      verticalPadding(height: .5),
                      Tooltip(
                        message: profileState.user.levelInfo != null
                            ? (profileState.user.levelInfo!.nextLevelMinimum !=
                                    null
                                ? "${AppLocalizations.of(context)!.remainingContributionsForNextLevelText} ${profileState.user.levelInfo!.nextLevelMinimum.toString()}"
                                : AppLocalizations.of(context)!
                                    .alreadyMaximumLevelText)
                            : AppLocalizations.of(context)!
                                .addMoreContributionsTooltipText,
                        preferBelow: false,
                        triggerMode: TooltipTriggerMode.tap,
                        child: Row(
                          children: [
                            Text(
                              profileState.user.levelInfo != null
                                  ? "${AppLocalizations.of(context)!.level} ${profileState.user.levelInfo!.level}"
                                  : "NA",
                              style: semiBold16.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.h),
                              height: 0.5.h,
                              width: 0.5.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey300,
                              ),
                            ),
                            Text(
                              profileState.user.levelInfo != null
                                  ? "${profileState.user.levelInfo!.levelName}"
                                  : "NA",
                              style: regular16.copyWith(
                                color: Colors.purple[900],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<UsernameAvailabilityBloc>()
                          .add(ResetUserNameToInitial());
                      context.pushNamed(
                        AppRoutes.editProfile,
                        extra: profileState.user,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.1.h,
                        horizontal: 3.5.w,
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.grey500, width: 0.5),
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.editProfileButtonText,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              const Divider(
                color: AppColors.dividerColor,
              ),
            ],
          );
        } else if (profileState is GetUserProfileError) {
          return ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_internet_1.svg",
              title: AppLocalizations.of(context)!.profileFailText,
              description: AppLocalizations.of(context)!.tryAgainText,
              onPressed: () {
                context.read<GetUserProfileBloc>().add(
                      GetUserProfileEvent(
                        userId: user!.id!,
                      ),
                    );
              });
        } else {
          return Container();
        }
      }, // Return a default widget if neither loading nor loaded
    );
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          uri.host.isNotEmpty &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

getPrefix(int i) {
  if (i == 1) {
    return "st";
  } else if (i == 2) {
    return "nd";
  } else if (i == 3) {
    return "rd";
  }
  return "th";
}
