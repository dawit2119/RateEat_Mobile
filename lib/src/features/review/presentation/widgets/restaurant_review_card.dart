import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/utils/date_parser.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/flag_review.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/review_image_stack.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';

import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_event.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import '../../../vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'expandableComment.dart';

class RestaurantReviewsCard extends StatelessWidget {
  final Restaurant restaurant;
  final dynamic userReview;
  final String redirectionRoute;
  RestaurantReviewsCard({
    super.key,
    required this.userReview,
    required this.restaurant,
    this.redirectionRoute = AppRoutes.restaurantDetail,
  });

  //*Get Current User
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.othersProfilePage,
          pathParameters: {"userId": userReview.user!.id},
        );
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: userReview.user?.image ?? "",
                      width: 9.w,
                      height: 9.w,
                      memCacheHeight: (9.w).cacheSize(context),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Use Text.rich for perfect alignment
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.poppins(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "${userReview.user?.firstName ?? ""} ${userReview.user?.lastName ?? ""} ",
                              ),
                              if ((userReview.user?.verified ?? 0) == 1 ||
                                  (userReview.user?.verified ?? 0) == 2)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 15.sp,
                                  ),
                                ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${userReview.user?.numberOfReviews ?? 0} Reviews',
                          style: GoogleFonts.poppins(
                              color: AppColors.textLight, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),
                  popUpMenu(),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: .5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDateTime(userReview.createdAt),
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    RatingBarIndicator(
                      itemBuilder: (context, index) {
                        return SvgPicture.asset(
                          "assets/icons/star_full_rounded.svg",
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        );
                      },
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.3),
                      unratedColor: AppColors.grey200,
                      itemSize: 1.65.h,
                      itemCount: 5,
                      rating: userReview.rating ?? 0.0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: .6.h),
              // *Comment Section
              userReview.comment != "" && userReview.comment != null
                  ? ExpandableComment(comment: userReview.comment!)
                  : Text(
                      AppLocalizations.of(context)!.noCommentText,
                      style: GoogleFonts.poppins(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        fontSize: 14.sp,
                      ),
                    ),

              SizedBox(height: .1.h),
              // *Images Section
              (userReview.images?.isNotEmpty ?? false) ||
                      (userReview.videos?.isNotEmpty ?? false)
                  ? ReviewStackImage(
                      imageURLs: userReview.images ?? [],
                      videos: userReview.videos ?? [],
                    )
                  : Container(),

              SizedBox(height: .1.h),
              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 1.h),
              BlocProvider(
                create: (context) => VoteOnReviewBloc(
                  VoteOnReviewInitial(
                    upVotes: userReview.upVote ?? 0,
                    downVotes: userReview.downVote ?? 0,
                    flag: userReview.voted ?? 0,
                  ),
                  upVoteItemReviewUseCase: dpLocator<UpVoteItemReviewUseCase>(),
                  downVoteItemReviewUseCase:
                      dpLocator<DownVoteItemReviewUseCase>(),
                  upVoteRestaurantReviewUseCase:
                      dpLocator<UpVoteRestaurantReviewUseCase>(),
                  downVoteRestaurantReviewUseCase:
                      dpLocator<DownVoteRestaurantReviewUseCase>(),
                ),
                child: BlocConsumer<VoteOnReviewBloc, VoteOnReviewState>(
                  listener: (context, voteState) {
                    if (voteState is VoteOnReviewFailed) {
                      showCustomToast(
                        context: context,
                        toastMessage: "Unable to process vote. Try again.",
                        toastType: ToastType.error,
                      );
                    }
                  },
                  builder: (context, voteState) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user == null) {
                              _showLoginDialog(
                                context,
                                restaurant: restaurant,
                              );
                              return;
                            }
                            var voteBloc = context.read<VoteOnReviewBloc>();
                            if (voteState.flag == -1) {
                              voteBloc.add(
                                TriggerDownVote(voteAction: VoteAction.remove),
                              );
                              // add upVote state
                              voteBloc.add(
                                TriggerUpVote(voteAction: VoteAction.add),
                              );
                              voteBloc.add(
                                RegisterUpVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.add,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            } else if (voteState.flag == 0) {
                              // Just add upVote
                              voteBloc.add(
                                TriggerUpVote(voteAction: VoteAction.add),
                              );
                              voteBloc.add(
                                RegisterUpVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.add,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            } else if (voteState.flag == 1) {
                              // Remove the upVote
                              voteBloc.add(
                                TriggerUpVote(voteAction: VoteAction.remove),
                              );
                              voteBloc.add(
                                RegisterUpVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.remove,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              boxShadow: elevation_2,

                              borderRadius: BorderRadius.circular(8),
                              color: voteState.flag == 1
                                  ? const Color.fromARGB(
                                      255, 6, 246, 14) // Active like color
                                  : const Color.fromARGB(255, 141, 204,
                                      143), // Inactive like color
                            ),
                            child: Center(
                              child: Icon(
                                Icons.thumb_up_alt, // Like icon
                                color: voteState.flag == 1
                                    ? Colors.white
                                    : Colors.black,
                                size: 11,
                              ),
                            ),
                          ),
                        ),
                        horizontalPadding(width: 1),
                        Text(
                          '${voteState.upVotes}',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        horizontalPadding(width: 3),
                        GestureDetector(
                          //? DownVote button
                          onTap: () {
                            if (user == null) {
                              _showLoginDialog(
                                context,
                                restaurant: restaurant,
                              );
                              return;
                            }
                            var voteBloc = context.read<VoteOnReviewBloc>();
                            if (voteState.flag == -1) {
                              // Remove the downVote
                              voteBloc.add(TriggerDownVote(
                                  voteAction: VoteAction.remove));
                              voteBloc.add(
                                RegisterDownVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.remove,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            } else if (voteState.flag == 0) {
                              // Register downVote
                              voteBloc.add(
                                  TriggerDownVote(voteAction: VoteAction.add));
                              voteBloc.add(
                                RegisterDownVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.add,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            } else if (voteState.flag == 1) {
                              // remove the upVote
                              voteBloc.add(
                                  TriggerUpVote(voteAction: VoteAction.remove));
                              // register downVote
                              voteBloc.add(
                                  TriggerDownVote(voteAction: VoteAction.add));
                              voteBloc.add(
                                RegisterDownVoteOnReview(
                                  userId: user!.id!,
                                  reviewId: userReview.id,
                                  voteAction: VoteAction.add,
                                  voteEntity: VoteEntity.restaurant,
                                  prevState: voteState,
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              boxShadow: elevation_2,

                              borderRadius: BorderRadius.circular(8),
                              color: voteState.flag == -1
                                  ? const Color.fromARGB(
                                      255, 242, 20, 4) // Active like color
                                  : const Color.fromARGB(
                                      255, 229, 70, 59), // Inactive like color
                            ),
                            child: Center(
                              child: Icon(
                                Icons.thumb_down_alt, // Like icon
                                color: voteState.flag == -1
                                    ? Colors.white
                                    : Colors.black,
                                size: 11,
                              ),
                            ),
                          ),
                        ),
                        horizontalPadding(width: 1),
                        Text(
                          '${voteState.downVotes}',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  PopupMenuButton<String> popUpMenu() {
    return PopupMenuButton(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.more_vert, size: 19.sp),
      ),
      itemBuilder: (BuildContext context) => [
        if (user == null || (user != null && user!.id != userReview.user!.id))
          PopupMenuItem<String>(
            value: 'flag',
            child: TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return FlagReview(
                      reviewId: userReview.id,
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: 1.7.h,
                    color: Colors.red,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    AppLocalizations.of(context)!.reportText,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        if (user != null && user!.id == userReview.user!.id)
          PopupMenuItem<String>(
            value: 'edit',
            child: TextButton(
              onPressed: () {
                context.pop();
                context.pushNamed(
                  AppRoutes.editRestaurantReview,
                  pathParameters: {
                    'restaurantId': restaurant.id!,
                    'reviewId': userReview.id,
                  },
                  extra: {
                    "reviewContent": userReview,
                    'restaurant': restaurant
                  },
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: 1.7.h,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    AppLocalizations.of(context)!.editText,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        if (user != null && user!.id == userReview.user!.id)
          PopupMenuItem<String>(
            value: AppLocalizations.of(context)!.editText,
            child: TextButton(
              onPressed: () {
                context.pop();
                showDeleteConfirmationDialog(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 1.7.h,
                    color: Colors.red,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    AppLocalizations.of(context)!.deleteText,
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showLoginDialog(
    BuildContext context, {
    Restaurant? restaurant,
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
                  'routeName': redirectionRoute,
                  'restaurant': restaurant,
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

  Future<dynamic> showDeleteConfirmationDialog(BuildContext context) {
    final confirmationText = AppLocalizations.of(context)!.confirmationText;
    final deleteConfirmationText =
        AppLocalizations.of(context)!.deleteConfirmationText;
    final yesText = AppLocalizations.of(context)!.yesText;
    final noText = AppLocalizations.of(context)!.noText;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            confirmationText,
            style: GoogleFonts.poppins(
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
          content: Text(
            deleteConfirmationText,
            style: GoogleFonts.poppins(
              color: AppColors.textDark,
              fontWeight: FontWeight.w300,
              fontSize: 15.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<DeleteRestaurantReviewBloc>().add(
                      DeleteRestaurantReviewRequestEvent(
                        deleteRestaurantReviewRequestModel:
                            DeleteRestaurantReviewRequestModel(
                          restaurantId: restaurant.id!,
                          reviewId: userReview.id,
                        ),
                      ),
                    );
                Navigator.pop(context);
              },
              child: Text(
                yesText,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                noText,
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
