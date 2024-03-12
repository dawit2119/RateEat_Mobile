import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/preview_selected_image.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/preview_selected_video.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late List<XFile> imageList;
  late List<XFile> videoList;

  get screenHeight => null;

  @override
  void initState() {
    final files = context
        .read<SimpleReviewStepperBloc>()
        .state
        .simpleAddReviewStepperProps;
    imageList = files.images ?? [];
    videoList = files.videos ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = SizeConfig.screenHeight;
    final screenWidth = SizeConfig.screenWidth;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          // AppLocalizations.of(context)!.selectedFilesText,
          AppLocalizations.of(context)!.selectMediaText,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        toolbarHeight: screenHeight * 0.07,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.015, left: screenWidth * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: screenHeight * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    shape: BoxShape.circle),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.01),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //******************************************Selected Images and videos  List View ***********************************************
              SizedBox(
                height: 2.h,
              ),
              BlocBuilder<SimpleReviewStepperBloc, SimpleReviewStepperState>(
                  builder: (context, state) {
                return (state.simpleAddReviewStepperProps.images != null &&
                            state.simpleAddReviewStepperProps.images!
                                .isNotEmpty) ||
                        (state.simpleAddReviewStepperProps.videos != null &&
                            state
                                .simpleAddReviewStepperProps.videos!.isNotEmpty)
                    ? Text(
                        // AppLocalizations.of(context)!.imagesText,
                        AppLocalizations.of(context)!
                            .selectedImagesAndVideosText,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 2.3.h,
                        ),
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context)!.notSelectedText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 1.7.h,
                          ),
                        ),
                      );
              }),
              SizedBox(height: screenHeight * 0.018),
              MediaListView(
                videoList: videoList,
                imageList: imageList,
                onRemove: (index, isImage) {
                  setState(() {
                    if (isImage) {
                      imageList.removeAt(index);
                      context.read<SimpleReviewStepperBloc>().add(
                            SimpleReviewStepperUpdate(
                              images: imageList,
                            ),
                          );
                    } else {
                      videoList.removeAt(index);
                      context.read<SimpleReviewStepperBloc>().add(
                            SimpleReviewStepperUpdate(
                              videos: videoList,
                            ),
                          );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
      //******************************************Continue Button ***********************************************
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          final state = context.read<SimpleReviewStepperBloc>().state;
          final toastMessage =
              AppLocalizations.of(context)!.cannotUploadMoreThanFiveText;
          if (state.simpleAddReviewStepperProps.images != null &&
              state.simpleAddReviewStepperProps.images!.isNotEmpty &&
              state.simpleAddReviewStepperProps.images!.length > 5) {
            showCustomToast(
                context: context,
                toastMessage: toastMessage,
                toastType: ToastType.warning);
          } else if (state.simpleAddReviewStepperProps.videos != null &&
              state.simpleAddReviewStepperProps.videos!.isNotEmpty &&
              state.simpleAddReviewStepperProps.videos!.length > 5) {
            showCustomToast(
                context: context,
                toastMessage: toastMessage,
                toastType: ToastType.warning);
          } else if (state.simpleAddReviewStepperProps.images!.isEmpty &&
              state.simpleAddReviewStepperProps.videos!.isEmpty) {
            showCustomToast(
                context: context,
                toastMessage: toastMessage,
                toastType: ToastType.warning);
          } else {
            context.pushNamed(
              AppRoutes.quickAddReviewRestaurantSelect,
            );
          }
        },
        label: SizedBox(
          height: 6.h,
          width: 83.w,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.continueText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MediaListView extends StatelessWidget {
  final List<XFile> imageList;
  final List<XFile> videoList;
  final Function(int, bool)? onRemove;

  const MediaListView({
    super.key,
    required this.imageList,
    required this.videoList,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 1.h, // Adjust the spacing between items as needed
      runSpacing: 8.0, // Adjust the run spacing as needed
      children: List.generate(
        imageList.length + videoList.length,
        (index) => InkWell(
          onTap: index < imageList.length
              ? () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        insetPadding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PreviewImage(imagePath: imageList[index].path),
                              Positioned(
                                top: 4.h,
                                right: 3.w,
                                child: Container(
                                  height: 5.h,
                                  width: 5.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(.5),
                                    boxShadow: [...elevation_4],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/x.svg',
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => PreviewVideo(
                      videoPath: videoList[index - imageList.length].path,
                      onClose: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
          child: index < imageList.length
              ? SelectedImageCard(
                  mediaPath: imageList[index].path,
                  onRemove: () {
                    if (onRemove != null) {
                      onRemove!(index, index < imageList.length);
                    }
                  },
                )
              : SelectedVideoCard(
                  mediaPath: videoList[index - imageList.length].path,
                  onRemove: () {
                    if (onRemove != null) {
                      onRemove!(
                          index - imageList.length, index < imageList.length);
                    }
                  },
                ),
        ),
      ),
    );
  }
}

class SelectedImageCard extends StatelessWidget {
  final String mediaPath;
  final VoidCallback? onRemove;

  const SelectedImageCard({super.key, required this.mediaPath, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            width: 27.w,
            height: 27.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Image.file(
              File(mediaPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 1.h,
            right: 1.h,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6.0),
                child: const Icon(
                  Icons.close,
                  color: AppColors.grey700,
                  size: 12.0,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 4.h,
            width: 10.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Iconsax.gallery,
                size: 2.h,
                color: AppColors.grey300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectedVideoCard extends StatelessWidget {
  final String mediaPath;
  final VoidCallback? onRemove;

  const SelectedVideoCard({super.key, required this.mediaPath, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            width: 27.w,
            height: 27.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: FutureBuilder<Uint8List?>(
              future: VideoThumbnail.thumbnailData(
                video: mediaPath,
                imageFormat: ImageFormat.JPEG, // Specify image format
                quality: 100, // Specify quality
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: SizeConfig.screenHeight * 0.13,
                      height: SizeConfig.screenHeight * 0.13,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ); // Placeholder for loading state
                } else if (snapshot.hasError) {
                  return Container(
                    width: SizeConfig.screenHeight * 0.13,
                    height: SizeConfig.screenHeight * 0.13,
                    color: AppColors.grey100,
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: elevation_4,
                      image: DecorationImage(
                        image: MemoryImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.grey100,
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.play_circle5,
                        color: Colors.white.withOpacity(0.6),
                        size: 28,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 35,
                    width: 35,
                    color: AppColors.grey100,
                  );
                }
              },
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 1.h,
            right: 1.h,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6.0),
                child: const Icon(
                  Icons.close,
                  color: AppColors.grey700,
                  size: 12.0,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 4.h,
            width: 10.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Iconsax.video_play,
                size: 2.h,
                color: AppColors.grey300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
