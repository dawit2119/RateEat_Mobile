import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/utils/date_parser.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_draft_review/delete_draft_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_response.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class DraftReviewCard extends StatelessWidget {
  final SavedReviewsResponse savedReview;

  const DraftReviewCard({super.key, required this.savedReview});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          (savedReview.item != null) ? savedReview.item!.itemName : "Food",
          style: subTitleTextStyle,
        ),
        subtitle: SizedBox(
          width: SizeConfig.screenWidth * .55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (savedReview.item != null)
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant,
                      color: Colors.red,
                      size: 13,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(savedReview.item!.restaurantName!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleTextStyle),
                    ),
                  ],
                ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                formatDateTime(savedReview.createdAt),
                style: GoogleFonts.poppins(
                  color: Colors.grey, // Adjust the color as needed
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDeleteConfirmationDialog(context, SizeConfig.screenHeight);
          },
        ),
        onTap: () {
          context.pushNamed(
            AppRoutes.sendSavedReview,
            extra: {
              "reviewContent": savedReview,
            },
          );
        },
        leading: Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: CachedNetworkImage(
            imageUrl: savedReview.item!.imageUrl!,
            memCacheHeight: (10.w).cacheSize(context),
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                ),
                verticalPadding(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDeleteConfirmationDialog(
      BuildContext appContext, double screenHeight) {
    final confirmationText = AppLocalizations.of(appContext)!.confirmationText;
    final deleteConfirmationText =
        AppLocalizations.of(appContext)!.deleteConfirmationText;
    final yesText = AppLocalizations.of(appContext)!.yesText;
    final noText = AppLocalizations.of(appContext)!.noText;
    return showDialog(
      context: appContext,
      builder: (appContext) {
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
                appContext.read<DeleteDraftReviewBloc>().add(
                      DeleteDraftItemReviewRequestEvent(
                        deleteDraftItemReviewRequestModel:
                            DeleteDraftItemReviewRequestModel(
                          draftItemReviewId: savedReview.draftId!,
                          itemId: (savedReview.item != null)
                              ? savedReview.item!.itemId
                              : "",
                        ),
                      ),
                    );
                Navigator.pop(appContext);
              },
              child: Text(
                yesText,
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                  fontSize: screenHeight * 0.014,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(appContext);
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
