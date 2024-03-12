import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';

import 'package:rateeat_mobile/src/features/review/presentation/bloc/draft_to_review/draft_to_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/draft_review_info_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_video_display.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../user_profile/presentation/pages/custom_tab_bar.dart';

class SendDraftToReviewPage extends StatefulWidget {
  final dynamic reviewContent;
  const SendDraftToReviewPage({super.key, required this.reviewContent});

  @override
  SendDraftToReviewPageState createState() => SendDraftToReviewPageState();
}

class SendDraftToReviewPageState extends State<SendDraftToReviewPage> {
  double? rating = 5.0;
  final TextEditingController comment = TextEditingController();
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  late List<DraftFileContentModel> selectedImages = [];
  late List<DraftFileContentModel> selectedVideos = [];

  //* Handle Rating change
  void handleRatingChanged(double newRating) {
    rating = newRating;
  }

  @override
  void initState() {
    super.initState();
    selectedImages = widget.reviewContent.images;
    selectedVideos = widget.reviewContent.videos;
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dpLocator<DraftToReviewBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(
            onTap: () {
              context.pop();
            },
            title: AppLocalizations.of(context)!.addReviewText),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.8.h),
                  //* Item Image Card
                  if (widget.reviewContent.item != null)
                    DraftReviewInfoCard(
                      item: widget.reviewContent.item,
                    ),
                  SizedBox(height: 2.3.h),

                  //* Rating Input
                  StarRatingInput(
                    rating: rating,
                    onRatingChanged: handleRatingChanged,
                  ),
                  SizedBox(height: 2.3.h),

                  //* Comment Section
                  InputTextfield(
                    title: AppLocalizations.of(context)!.addCommentText,
                    textEditingController: comment,
                  ),
                  SizedBox(height: 2.3.h),

                  //* Upload Files section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Remote Image review
                      selectedImages.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saved Images",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.screenHeight * 0.018,
                                  ),
                                ),
                                SizedBox(height: 1.5.h),
                                SizedBox(
                                  height: 10.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap:
                                        true, // Display images horizontally
                                    itemCount: selectedImages.length,
                                    itemBuilder: (context, index) {
                                      // Create a custom widget for each selected image
                                      return SelectedImageDisplay(
                                        imagePath: selectedImages[index].url!,
                                        onRemove: () {},
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width: 2.w,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 2.3.h),

                      //* Remote Video review
                      selectedVideos.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Saved Videos",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.screenHeight * 0.018,
                                  ),
                                ),
                                SizedBox(height: 1.5.h),
                                SizedBox(
                                  height: 10.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: selectedVideos.length,
                                    itemBuilder: (context, index) {
                                      return SelectedVideoDisplay(
                                        videoPath: selectedVideos[index].url!,
                                        onRemove: () {},
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width: 2.w,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),

                  //* Submit Review Button
                  BlocListener<DraftToReviewBloc, DraftToReviewState>(
                    listener: (context, state) {
                      if (state is DraftToReviewSuccess) {
                        context.read<SavedReviewsPageCubit>().changePage(1);
                        context.read<UserReviewsPageCubit>().changePage(1);

                        context
                            .read<SavedReviewsBloc>()
                            .add(GetSavedReviewsEvent());
                        context.read<GetUserProfileBloc>().add(
                              GetUserProfileEvent(
                                userId: user!.id!,
                              ),
                            );

                        showCustomToast(
                          context: context,
                          toastMessage: "Item ${state.message}",
                          toastType: ToastType.success,
                        );

                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            comment.clear();
                          });
                          if (context.mounted) {
                            context.pop();
                          }
                        });
                      } else if (state is DraftToReviewFailure) {
                        showCustomToast(
                          context: context,
                          toastMessage: "Item ${state.message}",
                          toastType: ToastType.error,
                        );
                      } else {}
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: BlocBuilder<DraftToReviewBloc, DraftToReviewState>(
                        builder: (context, state) {
                          if (state is DraftToReviewLoading) {
                            return LoadingButton(
                              title: AppLocalizations.of(context)!.updatingText,
                              color: AppColors.primaryButtonColor,
                              onClick: () {},
                              loadingState: true,
                            );
                          } else {
                            return SubmitButton(
                              title: AppLocalizations.of(context)!.updateText,
                              color: AppColors.primaryButtonColor,
                              onClick: () {
                                context.read<DraftToReviewBloc>().add(
                                      SendDraftToReviewEvent(
                                        draftToReviewRequest:
                                            DraftToReviewRequestModel(
                                          draftItemReviewId:
                                              widget.reviewContent.draftId ??
                                                  "",
                                          itemId: widget
                                                  .reviewContent.item?.itemId ??
                                              "",
                                          rating: rating,
                                          comment: comment.text,
                                        ),
                                      ),
                                    );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
