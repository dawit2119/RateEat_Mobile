import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/utils/date_parser.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_review.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/review_image_stack.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/core.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';

import '../../../review/presentation/widgets/expandableComment.dart';
import '../../../vote_on_review/domain/use_cases/down_vote_item_review.dart';
import '../../../vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import '../../../vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import '../../../vote_on_review/presentation/bloc/vote_on_review_event.dart';
import '../../../vote_on_review/presentation/bloc/vote_on_review_state.dart';

class UserReviewCard extends StatelessWidget {
  final UserReview userReview;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

  UserReviewCard({super.key, required this.userReview});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (!userReview.reviewSubject!.isItem!) {
          context.pushNamed(
            AppRoutes.restaurantDetail,
            pathParameters: {"restaurantId": userReview.reviewSubject!.id!},
          );
        } else {
          context.pushNamed(
            AppRoutes.itemDetail,
            pathParameters: {"itemId": userReview.reviewSubject!.id!},
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.006, horizontal: screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: avatar, name, badge, menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    boxShadow: elevation_4,
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: userReview.reviewSubject!.imageUrl!,
                      memCacheHeight: (9.w).cacheSize(context),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.person)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              userReview.reviewSubject?.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenHeight * 0.014),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      (userReview.reviewSubject?.isItem ?? true)
                                          ? Colors.green
                                          : Colors.red),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              (userReview.reviewSubject?.isItem ?? true)
                                  ? AppLocalizations.of(context)!.singleMenuText
                                  : AppLocalizations.of(context)!
                                      .singleRestaurantText,
                              style: TextStyle(
                                fontSize: screenHeight * 0.012,
                                fontWeight: FontWeight.bold,
                                color:
                                    (userReview.reviewSubject?.isItem ?? true)
                                        ? Colors.green
                                        : AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          popUpMenu(screenHeight, screenWidth),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            formatDateTime(userReview.createdAt),
                            style: GoogleFonts.poppins(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              fontSize: screenHeight * 0.012,
                            ),
                          ),
                          SizedBox(width: 8),
                          RatingBarIndicator(
                            itemBuilder: (context, index) {
                              return SvgPicture.asset(
                                "assets/icons/star_full_rounded.svg",
                                colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor, BlendMode.srcIn),
                              );
                            },
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1),
                            unratedColor: AppColors.grey200,
                            itemSize: screenHeight * 0.0115,
                            itemCount: 5,
                            rating: userReview.rating!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            (userReview.comment ?? "").isNotEmpty
                ? ExpandableComment(comment: userReview.comment!)
                : Text(
                    AppLocalizations.of(context)!.noCommentText,
                    style: GoogleFonts.poppins(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      fontSize: screenHeight * 0.015,
                    ),
                  ),
            SizedBox(height: 8),
            (userReview.images.isNotEmpty ||
                    (userReview.videos?.isNotEmpty ?? false))
                ? ReviewStackImage(
                    imageURLs: userReview.images,
                    videos: userReview.videos ?? [],
                  )
                : Container(),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 12),
            BlocProvider(
              create: (context) => VoteOnReviewBloc(
                VoteOnReviewInitial(
                  upVotes: userReview.upVote!,
                  downVotes: userReview.downVote!,
                  flag: userReview.voted!,
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
                      toastMessage: AppLocalizations.of(context)!.voteErrorText,
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
                              userId: userReview.userId!,
                            );
                            return;
                          }
                          var voteBloc = context.read<VoteOnReviewBloc>();
                          if (voteState.flag == -1) {
                            voteBloc.add(
                              TriggerDownVote(voteAction: VoteAction.remove),
                            );
                            voteBloc.add(
                              TriggerUpVote(voteAction: VoteAction.add),
                            );
                            voteBloc.add(
                              RegisterUpVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.add,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          } else if (voteState.flag == 0) {
                            voteBloc.add(
                              TriggerUpVote(voteAction: VoteAction.add),
                            );
                            voteBloc.add(
                              RegisterUpVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.add,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          } else if (voteState.flag == 1) {
                            // Remove the upvote
                            voteBloc.add(
                              TriggerUpVote(voteAction: VoteAction.remove),
                            );
                            voteBloc.add(
                              RegisterUpVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.remove,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            boxShadow: elevation_4,
                            borderRadius: BorderRadius.circular(8),
                            color: voteState.flag == 1
                                ? const Color.fromARGB(
                                    255, 6, 246, 14) // Active like color
                                : const Color.fromARGB(255, 141, 204, 143),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.thumb_up_alt,
                              size: 11,
                              color: voteState.flag == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      horizontalPadding(width: 1),
                      Text(
                        "${voteState.upVotes}",
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.014,
                        ),
                      ),
                      horizontalPadding(width: 3),
                      GestureDetector(
                        onTap: () {
                          if (user == null) {
                            _showLoginDialog(
                              context,
                              userId: userReview.userId!,
                            );
                            return;
                          }
                          var voteBloc = context.read<VoteOnReviewBloc>();
                          if (voteState.flag == -1) {
                            voteBloc.add(
                                TriggerDownVote(voteAction: VoteAction.remove));
                            voteBloc.add(
                              RegisterDownVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.remove,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          } else if (voteState.flag == 0) {
                            voteBloc.add(
                                TriggerDownVote(voteAction: VoteAction.add));
                            voteBloc.add(
                              RegisterDownVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.add,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          } else if (voteState.flag == 1) {
                            // remove the upoVte
                            voteBloc.add(
                                TriggerUpVote(voteAction: VoteAction.remove));
                            // register downVote
                            voteBloc.add(
                                TriggerDownVote(voteAction: VoteAction.add));
                            voteBloc.add(
                              RegisterDownVoteOnReview(
                                userId: user!.id!,
                                reviewId: userReview.id!,
                                voteAction: VoteAction.add,
                                voteEntity:
                                    userReview.reviewSubject?.isItem ?? true
                                        ? VoteEntity.item
                                        : VoteEntity.restaurant,
                                prevState: voteState,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            boxShadow: elevation_4,
                            borderRadius: BorderRadius.circular(8),
                            color: voteState.flag == -1
                                ? const Color.fromARGB(
                                    255, 242, 20, 4) // Active like color
                                : const Color.fromARGB(255, 229, 70, 59),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.thumb_down_alt,
                              size: 11,
                              color: voteState.flag == -1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      horizontalPadding(width: 1),
                      Text(
                        '${voteState.downVotes}',
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.014,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<String> popUpMenu(double screenHeight, double screenWidth) {
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
        if (user != null && user!.id == userReview.userId)
          PopupMenuItem<String>(
            value: 'edit',
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (userReview.reviewSubject!.isItem!) {
                  context.pushNamed(
                    AppRoutes.editItemReview,
                    pathParameters: {
                      'itemId': userReview.reviewSubject!.id!,
                      'reviewId': userReview.id!,
                    },
                    extra: {
                      "reviewContent": userReview,
                      'item': ItemModel(
                        itemId: userReview.reviewSubject!.id!,
                        itemName: userReview.reviewSubject!.name!,
                        imageUrl: userReview.reviewSubject?.imageUrl ?? '',
                        numberOfReviews: 0,
                      )
                    },
                  );
                } else {
                  context.pushNamed(
                    AppRoutes.editRestaurantReview,
                    pathParameters: {
                      'restaurantId': userReview.reviewSubject!.id!,
                      'reviewId': userReview.id!,
                    },
                    extra: {
                      "reviewContent": userReview,
                      'restaurant': RestaurantModel(
                        id: userReview.reviewSubject!.id!,
                        name: userReview.reviewSubject!.name,
                        restaurantImages: [
                          RestaurantMedia.fromJson(
                            {"url": userReview.reviewSubject!.imageUrl},
                          ),
                        ],
                      ),
                    },
                  );
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: screenHeight * 0.017,
                    color: Colors.blue,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    AppLocalizations.of(context)!.editText,
                    style: TextStyle(fontSize: screenHeight * 0.013),
                  ),
                ],
              ),
            ),
          ),
        if (user != null && user!.id == userReview.userId)
          PopupMenuItem<String>(
            value: AppLocalizations.of(context)!.deleteText,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDeleteConfirmationDialog(context, screenHeight);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: screenHeight * 0.017,
                    color: Colors.red,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    AppLocalizations.of(context)!.deleteText,
                    style: TextStyle(fontSize: screenHeight * 0.013),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<dynamic> showDeleteConfirmationDialog(
      BuildContext context, double screenHeight) {
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
              fontSize: screenHeight * 0.014,
            ),
          ),
          content: Text(
            deleteConfirmationText,
            style: GoogleFonts.poppins(
              color: AppColors.textDark,
              fontWeight: FontWeight.w300,
              fontSize: screenHeight * 0.014,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (userReview.reviewSubject!.isItem!) {
                  context.read<DeleteItemReviewBloc>().add(
                        DeleteItemReviewRequestEvent(
                          deleteItemReviewRequestModel:
                              DeleteItemReviewRequestModel(
                            itemId: userReview.reviewSubject!.id!,
                            reviewId: userReview.id!,
                          ),
                        ),
                      );
                } else {
                  context.read<DeleteRestaurantReviewBloc>().add(
                        DeleteRestaurantReviewRequestEvent(
                          deleteRestaurantReviewRequestModel:
                              DeleteRestaurantReviewRequestModel(
                            restaurantId: userReview.reviewSubject!.id!,
                            reviewId: userReview.id!,
                          ),
                        ),
                      );
                }
                Navigator.pop(context);
              },
              child: Text(
                yesText,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: screenHeight * 0.014,
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
                  fontSize: screenHeight * 0.014,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
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
