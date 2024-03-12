import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class StackedImagesDisplayWidget extends StatelessWidget {
  const StackedImagesDisplayWidget({
    super.key,
    required this.imageURLs,
    required this.videos,
  });

  final List<dynamic> imageURLs;
  final List<dynamic> videos;

  @override
  Widget build(BuildContext context) {
    List<dynamic> combinedList = imageURLs + videos;

    return SizedBox(
      height: 27.sp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            min(combinedList.length, 5),
            (index) {
              if (index < imageURLs.length) {
                return Positioned(
                  left: 16 * index.toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.textWhite,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textDark.withOpacity(.1),
                          blurRadius: 6.0,
                          offset: const Offset(-3.0, 3.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: imageURLs[index],
                        width: 25.sp,
                        height: 25.sp,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 25.sp,
                          height: 25.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.shimmerBaseColor,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: const SizedBox.expand(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 25.sp,
                          height: 25.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return FutureBuilder<Uint8List?>(
                  future: VideoThumbnail.thumbnailData(
                    video: combinedList[index],
                    imageFormat: ImageFormat.JPEG,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingAnimationWidget.dotsTriangle(
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ); // Placeholder for loading state
                    } else if (snapshot.hasError) {
                      return Container(
                        width: 25.sp,
                        height: 25.sp,
                        color: AppColors.grey100,
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.data != null) {
                      return Positioned(
                        left: 22 * index.toDouble(),
                        child: Container(
                          width: 25.sp,
                          height: 25.sp,
                          decoration: BoxDecoration(
                            boxShadow: elevation_4,
                            image: DecorationImage(
                              image: MemoryImage(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.grey100,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: 25.sp,
                        height: 25.sp,
                        color: AppColors.grey100,
                      );
                    }
                  },
                );
              }
            },
          ),
          if (combinedList.length > 5)
            Positioned(
              left: 22 * 4.toDouble(),
              child: Container(
                width: 25.sp,
                height: 25.sp,
                decoration: BoxDecoration(
                  boxShadow: elevation_4,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "+ ${combinedList.length - 5}",
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
