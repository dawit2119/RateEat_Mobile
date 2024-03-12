import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_item_review/edit_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_video_display.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/review_entity_info_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../homepage/data/models/item_model.dart';
import '../../../user_profile/presentation/pages/custom_tab_bar.dart';

class EditItemReviewPage extends StatefulWidget {
  final ItemModel item;
  final String? reviewId;
  final dynamic reviewContent;
  //used to inject mock image picker
  final ImagePicker? imagePicker;

  const EditItemReviewPage(
      {super.key,
      required this.item,
      this.reviewId,
      required this.reviewContent,
      this.imagePicker});

  @override
  EditItemReviewPageState createState() => EditItemReviewPageState();
}

class EditItemReviewPageState extends State<EditItemReviewPage> {
  double? rating;
  final TextEditingController comment = TextEditingController();
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  late final ImagePicker picker;
  //* Handle Rating change
  void handleRatingChanged(double newRating) {
    rating = newRating;
  }

  @override
  void initState() {
    super.initState();

    //* Comment and Rating
    comment.text = widget.reviewContent.comment ?? "";
    rating = widget.reviewContent.rating;
    picker = widget.imagePicker ?? ImagePicker();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  List<File> selectedImages = [];
  List<File> selectedVideos = [];
  //* Function to get list of files
  Future<void> pickMultipleMedia() async {
    if (selectedImages.length > 5 || selectedVideos.length > 5) {
      showCustomToast(
          context: context,
          toastMessage: "You can't add more than 5 files",
          toastType: ToastType.warning);
      return;
    }
    final pickedFiles = await picker.pickMultipleMedia(
      imageQuality: 20,
    );

    setState(() {
      if (pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          // Check file extension using regular expression
          final isImage = RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false)
              .hasMatch(pickedFile.path);
          final isVideo = RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false)
              .hasMatch(pickedFile.path);

          // Get file size in bytes
          final file = File(pickedFile.path);
          final fileSize = file.lengthSync();

          if (isImage && fileSize <= 5 * 1024 * 1024) {
            selectedImages.add(file);
          } else if (isVideo && fileSize <= 8 * 1024 * 1024) {
            selectedVideos.add(file);
          } else {
            // String fileName = file.path.split('/').last;
            String fileType = '';
            String fileSizeStr = '';

            // Check if the file is unsupported
            if (!isImage && !isVideo) {
              fileType = 'Unsupported';
              fileSizeStr = 'N/A';
              showCustomToast(
                context: context,
                toastMessage: '$fileType file',
                toastType: ToastType.error,
              );
            } else {
              fileType = isImage ? 'Image' : 'Video';
              fileSizeStr = isImage ? '5MB' : '8MB';
              showCustomToast(
                context: context,
                toastMessage: 'file size exceeds the limit $fileSizeStr.',
                toastType: ToastType.warning,
              );
            }
          }
        }
      } else {
        showCustomToast(
          context: context,
          toastMessage: 'Nothing is selected',
          toastType: ToastType.warning,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dpLocator<EditItemReviewBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(
            onTap: () {
              context.pop();
            },
            title: AppLocalizations.of(context)!.editCommentText),
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
                  ReviewEntityInfoCard(
                    item: widget.item,
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
                    title: AppLocalizations.of(context)!.editCommentText,
                    textEditingController: comment,
                  ),
                  SizedBox(height: 2.3.h),

                  //* Upload Files section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Upload Files Text
                      Text(
                        AppLocalizations.of(context)!.uploadFilesText,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 2.3.h,
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      //* Upload Files
                      Center(
                        child: InkWell(
                          onTap: () {
                            pickMultipleMedia();
                          },
                          child: Container(
                            width: 84.w,
                            height: 13.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: .2.h,
                                  blurRadius: .7.h,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  color: const Color(0xFF586069),
                                  size: 3.9.h,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.clickUploadText,
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF586069)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.8.h),

                      //* Preview Selected Images
                      selectedImages.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .selectedImagesText,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 1.8.h,
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
                                        imagePath: selectedImages[index].path,
                                        remoteSource: false,
                                        onRemove: () {
                                          setState(() {
                                            selectedImages.removeAt(index);
                                          });
                                        },
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
                            )
                          :
                          //* Previous Image review
                          widget.reviewContent.images!.isEmpty
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .previouslyUploadedImagesText,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 1.8.h,
                                      ),
                                    ),
                                    SizedBox(height: 1.5.h),
                                    SizedBox(
                                      height: 10.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap:
                                            true, // Display images horizontally
                                        itemCount:
                                            widget.reviewContent.images!.length,
                                        itemBuilder: (context, index) {
                                          // Create a custom widget for each selected image
                                          return SelectedImageDisplay(
                                            imagePath: widget.reviewContent
                                                .images![index]['url'],
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

                      //* Preview Selected Video
                      selectedVideos.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .selectedVideosText,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 1.8.h,
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
                                        videoPath: selectedVideos[index].path,
                                        remoteSource: false,
                                        onRemove: () {
                                          setState(() {
                                            selectedVideos.removeAt(index);
                                          });
                                        },
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
                            )
                          :
                          //* Previous Video review
                          widget.reviewContent.videos!.isEmpty
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .previouslyUploadedVideosText,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 1.8.h,
                                      ),
                                    ),
                                    SizedBox(height: 1.5.h),
                                    SizedBox(
                                      height: 10.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.reviewContent.videos!.length,
                                        itemBuilder: (context, index) {
                                          return SelectedVideoDisplay(
                                            videoPath: widget
                                                .reviewContent.videos![index],
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
                  BlocListener<EditItemReviewBloc, EditItemReviewState>(
                    listener: (context, state) {
                      if (state is EditItemReviewSuccess) {
                        context.read<UserReviewBloc>().add(
                              GetUserReviewEvent(
                                userId: user!.id!,
                              ),
                            );

                        context.read<UserReviewsPageCubit>().changePage(1);
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
                      } else if (state is EditItemReviewFailure) {
                        showCustomToast(
                          context: context,
                          toastMessage: "Item ${state.message}",
                          toastType: ToastType.warning,
                        );
                      } else {}
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child:
                          BlocBuilder<EditItemReviewBloc, EditItemReviewState>(
                        builder: (context, state) {
                          if (state is EditItemReviewLoading) {
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
                                context.read<EditItemReviewBloc>().add(
                                      EditItemReviewRequestEvent(
                                        editItemReviewRequest:
                                            EditItemReviewRequestModel(
                                          itemId: widget.item.itemId,
                                          reviewId: widget.reviewContent.id,
                                          rating: rating !=
                                                  widget.reviewContent.rating
                                              ? rating
                                              : null,
                                          comment: comment.text !=
                                                  widget.reviewContent.comment
                                              ? comment.text.trim()
                                              : null,
                                          images: selectedImages.isNotEmpty
                                              ? selectedImages
                                              : null,
                                          videos: selectedVideos.isNotEmpty
                                              ? selectedVideos
                                              : null,
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
