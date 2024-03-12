import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';

import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_item_review/add_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_video_display.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/review_entity_info_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../homepage/data/models/item_model.dart';
import '../../../notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';

class AddItemReviewPage extends StatefulWidget {
  final ItemModel? item;
  final String? loginRedirection;
  //used to inject mock image picker
  final ImagePicker? imagePicker;

  const AddItemReviewPage({
    super.key,
    this.item,
    this.loginRedirection,
    this.imagePicker,
  });

  @override
  AddItemReviewPageState createState() => AddItemReviewPageState();
}

class AddItemReviewPageState extends State<AddItemReviewPage> {
  final TextEditingController comment = TextEditingController();
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  late final ImagePicker picker;

  //* Handle Rating change
  double rating = 5;
  void handleRatingChanged(double newRating) {
    setState(() {
      rating = newRating;
    });
  }

  @override
  void initState() {
    super.initState();
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
        } else {
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
                toastMessage: '$fileType file ',
                toastType: ToastType.error,
              );
            }
          } else {
            fileType = isImage ? 'Image' : 'Video';
            fileSizeStr = isImage ? '5MB' : '8MB';
            if (mounted) {
              showCustomToast(
                context: context,
                toastMessage: 'file size exceeds the limit $fileSizeStr.',
                toastType: ToastType.error,
              );
            }
          }
        }
      }
    } else {
      if (mounted) {
        showCustomToast(
          context: context,
          toastMessage: 'Nothing is selected',
          toastType: ToastType.warning,
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dpLocator<AddItemReviewBloc>(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (widget.loginRedirection != null) {
            context.goNamed(
              AppRoutes.home,
            );
          } else {
            context.pop();
          }
        },
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
                    ReviewEntityInfoCard(
                      item: widget.item!,
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
                        //* Upload Files Text
                        Text(
                          AppLocalizations.of(context)!.uploadFilesText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 2.2.h,
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
                              )
                            : Container(),
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
                            : Container(),
                      ],
                    ),

                    //* Submit Review Button
                    BlocListener<AddItemReviewBloc, AddItemReviewState>(
                      listener: (context, state) {
                        if (state is AddItemReviewSuccess) {
                          showCustomToast(
                            context: context,
                            toastMessage:
                                AppLocalizations.of(context)!.itemText,
                            toastType: ToastType.success,
                          );
                          final user = dpLocator<AuthenticationLocalSource>()
                              .getUserCredential();

                          context.read<UnreadNotificationsCounterBloc>().add(
                                GetUnreadNotificationsCount(
                                  userId: user!.id!,
                                ),
                              );
                          setState(() {
                            comment.clear();
                          });
                          context.pop();
                          if (widget.loginRedirection != null) {
                            context.pop();
                          }
                        } else if (state is AddItemReviewFailure) {
                          showCustomToast(
                            context: context,
                            toastMessage:
                                "${AppLocalizations.of(context)!.itemText} ${state.message}",
                            toastType: ToastType.error,
                          );
                        } else {}
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child:
                            BlocBuilder<AddItemReviewBloc, AddItemReviewState>(
                          builder: (context, state) {
                            if (state is AddItemReviewLoading) {
                              return LoadingButton(
                                title: AppLocalizations.of(context)!
                                    .submittingText,
                                color: AppColors.primaryButtonColor,
                                onClick: () {},
                                loadingState: true,
                              );
                            } else {
                              return SubmitButton(
                                title: AppLocalizations.of(context)!.submitText,
                                color: AppColors.primaryButtonColor,
                                onClick: () {
                                  context.read<AddItemReviewBloc>().add(
                                        AddItemReviewRequestEvent(
                                          addItemReviewRequest:
                                              AddItemReviewRequestModel(
                                            itemId: widget.item!.itemId,
                                            rating: rating,
                                            comment: comment.text.trim(),
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
      ),
    );
  }
}
