import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReviewStackImage extends StatelessWidget {
  const ReviewStackImage({
    super.key,
    required this.imageURLs,
    required this.videos,
  });

  final List<dynamic> imageURLs;
  final List<dynamic> videos;

  // Helper method to get URL from either ReviewMedia or ReviewMediaModel
  String? _getMediaUrl(dynamic media) {
    if (media is ReviewMedia) {
      return media.url;
    } else if (media is Map<String, dynamic>) {
      return media['url'];
    }
    return null;
  }

  Widget _buildMediaWidget(
    dynamic media,
    double width,
    double height,
    BuildContext context,
    bool isImage, {
    int? remainingCount,
  }) {
    final url = _getMediaUrl(media) ?? '';

    Widget mediaWidget;

    if (isImage) {
      mediaWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          width: width,
          height: height,
          fit: BoxFit.cover,
          cacheHeight: (height).cacheSize(context),
          cacheWidth: (width).cacheSize(context),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              color: AppColors.shimmerBaseColor,
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: const SizedBox.expand(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.error, color: Colors.white),
            );
          },
        ),
      );
    } else {
      mediaWidget = FutureBuilder<Uint8List?>(
        future: VideoThumbnail.thumbnailData(
          video: url,
          imageFormat: ImageFormat.JPEG,
          quality: 100,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: LoadingAnimationWidget.dotsTriangle(
                color: AppColors.primaryColor,
                size: 30,
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          } else {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    snapshot.data!,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white70,
                      size: min(width, height) / 3,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      );
    }

    // Add overlay for remaining count
    if (remainingCount != null && remainingCount > 0) {
      return Stack(
        children: [
          mediaWidget,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: min(width, height) / 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return mediaWidget;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> combinedList = [...imageURLs, ...videos];
    final int totalCount = combinedList.length;

    if (totalCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) => ImageDialog(
            pageController: PageController(initialPage: 0),
            imageURLs: imageURLs,
            mediaList: videos,
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use LayoutBuilder to get actual available width
          final double availableWidth = constraints.maxWidth;
          final double spacing = 8;
          final double maxWidth = availableWidth - 16; // Conservative padding

          return _buildLayout(
              context, combinedList, totalCount, maxWidth, spacing);
        },
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    List<dynamic> combinedList,
    int totalCount,
    double maxWidth,
    double spacing,
  ) {
    switch (totalCount) {
      case 1:
        return _buildSingleLayout(context, combinedList, maxWidth);
      case 2:
        return _buildTwoLayout(context, combinedList, maxWidth, spacing);
      case 3:
        return _buildThreeLayout(context, combinedList, maxWidth, spacing);
      default:
        return _buildFourPlusLayout(
            context, combinedList, totalCount, maxWidth, spacing);
    }
  }

  // 1 image: Full width
  Widget _buildSingleLayout(
    BuildContext context,
    List<dynamic> combinedList,
    double maxWidth,
  ) {
    final double height = maxWidth * 0.6; // Aspect ratio
    return Container(
      width: maxWidth,
      child: _buildMediaWidget(
        combinedList[0],
        maxWidth,
        height,
        context,
        0 < imageURLs.length,
      ),
    );
  }

  // 2 images: Side by side (fixed overflow with Flexible)
  Widget _buildTwoLayout(
    BuildContext context,
    List<dynamic> combinedList,
    double maxWidth,
    double spacing,
  ) {
    final double itemWidth = (maxWidth - spacing) / 2;
    final double itemHeight =
        itemWidth * 0.75; // More conservative height ratio

    return Row(
      children: [
        Flexible(
          flex: 1,
          child: _buildMediaWidget(
            combinedList[0],
            itemWidth,
            itemHeight,
            context,
            0 < imageURLs.length,
          ),
        ),
        SizedBox(width: spacing),
        Flexible(
          flex: 1,
          child: _buildMediaWidget(
            combinedList[1],
            itemWidth,
            itemHeight,
            context,
            1 < imageURLs.length,
          ),
        ),
      ],
    );
  }

  // 3 images: 2 on top, 1 on bottom (centered)
  Widget _buildThreeLayout(
    BuildContext context,
    List<dynamic> combinedList,
    double maxWidth,
    double spacing,
  ) {
    final double topItemWidth = (maxWidth - spacing) / 2;
    final double topItemHeight = topItemWidth * 0.75;
    final double bottomItemWidth = topItemWidth;
    final double bottomItemHeight = topItemHeight;

    return Column(
      children: [
        // Top row: 2 images
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[0],
                topItemWidth,
                topItemHeight,
                context,
                0 < imageURLs.length,
              ),
            ),
            SizedBox(width: spacing),
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[1],
                topItemWidth,
                topItemHeight,
                context,
                1 < imageURLs.length,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        // Bottom row: 1 image (centered)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: bottomItemWidth,
              child: _buildMediaWidget(
                combinedList[2],
                bottomItemWidth,
                bottomItemHeight,
                context,
                2 < imageURLs.length,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 4+ images: 2 on top, 2 on bottom with "+N more" overlay
  Widget _buildFourPlusLayout(
    BuildContext context,
    List<dynamic> combinedList,
    int totalCount,
    double maxWidth,
    double spacing,
  ) {
    final double itemWidth = (maxWidth - spacing) / 2;
    final double itemHeight = itemWidth * 0.75;
    final int remainingCount = totalCount - 4;

    return Column(
      children: [
        // Top row: 2 images
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[0],
                itemWidth,
                itemHeight,
                context,
                0 < imageURLs.length,
              ),
            ),
            SizedBox(width: spacing),
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[1],
                itemWidth,
                itemHeight,
                context,
                1 < imageURLs.length,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        // Bottom row: 2 images (last one with overlay if more than 4)
        Row(
          children: [
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[2],
                itemWidth,
                itemHeight,
                context,
                2 < imageURLs.length,
              ),
            ),
            SizedBox(width: spacing),
            Flexible(
              flex: 1,
              child: _buildMediaWidget(
                combinedList[3],
                itemWidth,
                itemHeight,
                context,
                3 < imageURLs.length,
                remainingCount: remainingCount > 0 ? remainingCount : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
