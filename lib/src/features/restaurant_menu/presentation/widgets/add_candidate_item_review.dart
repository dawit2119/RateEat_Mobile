import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/candidate_item.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_video_display.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import '../../../review/data/models/add_item_review_request_model.dart';
import '../../../review/presentation/bloc/add_item_review/add_item_review_bloc.dart';
import '../../../review/presentation/widgets/review_entity_info_card.dart';
import '../bloc/candidate_item/candidate_item_bloc.dart';
import '../bloc/candidate_item/candidate_item_state.dart';
import 'add_candidate_item.dart';

class AddCandidateItemReviewPage extends StatefulWidget {
  const AddCandidateItemReviewPage({
    super.key,
  });

  @override
  AddCandidateItemReviewPageState createState() =>
      AddCandidateItemReviewPageState();
}

class AddCandidateItemReviewPageState
    extends State<AddCandidateItemReviewPage> {
  final TextEditingController comment = TextEditingController();
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  SelecteImagesCubit selecteImagesCubit = dpLocator.get<SelecteImagesCubit>();
  double rating = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  final picker = ImagePicker();
  List<File> selectedImages = [];
  List<File> selectedVideos = [];
  //* Function to get list of files
  Future<void> pickMultipleMedia() async {
    final pickedFiles = await picker.pickMultipleMedia(
      imageQuality: 60,
    );
    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        // Check file extension using regular expression
        final isImage = RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false)
            .hasMatch(pickedFile.path);
        final isVideo = RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false)
            .hasMatch(pickedFile.path);

        // Get file size in bytes
        final file = File(pickedFile.path);
        // final file = isImage ? await ImageUploader.compressFile(file) : file;
        final fileSize = file.lengthSync();

        if (isImage && fileSize <= 5 * 1024 * 1024) {
          selectedImages.add(file);
        } else if (isVideo && fileSize <= 8 * 1024 * 1024) {
          selectedVideos.add(file);
        } else if (context.mounted) {
          // String fileName = img.path.split('/').last;
          String fileType = '';
          String fileSizeStr = '';
          // Check if the file is unsupported
          if (!isImage && !isVideo) {
            fileType = 'Unsupported';
            fileSizeStr = 'N/A';

            if (mounted) {
              showCustomToast(
                context: context,
                toastMessage: '$fileType file',
                toastType: ToastType.error,
              );
            }
          } else {
            fileType = isImage ? 'Image' : 'Video';
            fileSizeStr = isImage ? '10MB' : '100MB';

            if (mounted) {
              showCustomToast(
                context: context,
                toastMessage:
                    '${AppLocalizations.of(context)!.fileSizeLimitText} $fileSizeStr.',
                toastType: ToastType.warning,
              );
            }
          }
        }
      }
    } else if (mounted) {
      showCustomToast(
        context: context,
        toastMessage: AppLocalizations.of(context)!.nothingSelectedText,
        toastType: ToastType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateItemBloc, CandidateItemState>(
        builder: (context, candidateItemState) {
      if (candidateItemState is CandidateItemAddFailed) {
        return ErrorAndInfoDisplayWidget(
          title: "Unable to get item info.",
          description:
              "${AppLocalizations.of(context)!.itemText} ${candidateItemState.message} \nPlease try again.",
          assetImage: 'assets/images/Error_page_2.png',
        );
      } else if (candidateItemState is CandidateItemAdded) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5,
                    width: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.grey300,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: const WidgetStatePropertyAll(
                        AppColors.primaryLightColor,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      context.pop();
                      context.read<CandidateItemCubit>().changeIndex(0);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.skipText,
                      textAlign: TextAlign.right,
                      style: regular16.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Add Item Review",
                  style: semiBold18,
                ),
                verticalPadding(height: 2),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReviewEntityInfoCard(
                          item: (candidateItemState.candidateItem),
                        ),
                        verticalPadding(height: 3),
                        //* Rating Input
                        StarRatingInput(
                          rating: rating,
                          title: "How is the food?",
                          description: "Take a moment to rate your experience.",
                          onRatingChanged: (value) {
                            rating = value;
                          },
                        ),
                        verticalPadding(height: 3),
                        //* Comment Section
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: InputTextfield(
                            title: "Write a review",
                            textEditingController: comment,
                          ),
                        ),
                        verticalPadding(height: 2),
                        //* Upload Files section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* Upload Files Text
                            Text(
                              AppLocalizations.of(context)!.uploadFilesText,
                              style: medium18,
                            ),
                            verticalPadding(height: 1.2),
                            //* Upload Files
                            Center(
                              child: InkWell(
                                onTap: () {
                                  pickMultipleMedia();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  width: double.infinity,
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
                                      const Icon(
                                        Iconsax.cloud,
                                        color: AppColors.grey600,
                                        size: 32,
                                      ),
                                      verticalPadding(height: 1),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .clickUploadText,
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
                            if (selectedImages.isNotEmpty)
                              Column(
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
                                    height: 10
                                        .h, // You can adjust the height as needed
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
                              ),

                            SizedBox(height: 2.3.h),

                            //* Preview Selected Video
                            if (selectedVideos.isNotEmpty)
                              Column(
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
                              ),
                          ],
                        ),

                        // * Submit Review Button
                        BlocConsumer<AddItemReviewBloc, AddItemReviewState>(
                          listener: (context, addItemReviewState) {
                            if (addItemReviewState is AddItemReviewSuccess) {
                              showCustomToast(
                                context: context,
                                toastMessage:
                                    "${AppLocalizations.of(context)!.itemText} review added successfully.",
                                toastType: ToastType.success,
                              );
                              final user =
                                  dpLocator<AuthenticationLocalSource>()
                                      .getUserCredential();

                              context
                                  .read<UnreadNotificationsCounterBloc>()
                                  .add(
                                    GetUnreadNotificationsCount(
                                      userId: user!.id!,
                                    ),
                                  );
                              setState(() {
                                comment.clear();
                              });
                              context.read<CandidateItemCubit>().changeIndex(
                                    0,
                                  );
                              context.pop();
                            } else if (addItemReviewState
                                is AddItemReviewFailure) {
                              showCustomToast(
                                context: context,
                                toastMessage:
                                    "${AppLocalizations.of(context)!.itemText} ${addItemReviewState.message}",
                                toastType: ToastType.error,
                              );
                            } else {}
                          },
                          builder: (context, addItemReviewState) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              child: SizedBox(
                                width: 90.w,
                                child: SubmitButton(
                                  isLoading: addItemReviewState
                                      is AddItemReviewLoading,
                                  title:
                                      AppLocalizations.of(context)!.submitText,
                                  color: AppColors.primaryButtonColor,
                                  onClick: () {
                                    context.read<AddItemReviewBloc>().add(
                                          AddItemReviewRequestEvent(
                                            addItemReviewRequest:
                                                AddItemReviewRequestModel(
                                              itemId: candidateItemState
                                                  .candidateItem.itemId,
                                              rating: rating,
                                              comment: comment.text.trim(),
                                              images: selectedImages.isNotEmpty
                                                  ? selectedImages
                                                  : null,
                                              videos: selectedVideos.isNotEmpty
                                                  ? selectedVideos
                                                  : null,
                                            ),
                                            isCandidateItem: true,
                                          ),
                                        );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Column(
          children: [],
        );
      }
    });
  }
}
