import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/highlight_animated_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReviewImageVideoHighlight extends StatefulWidget {
  final List<HighlightModel> highlights;
  const ReviewImageVideoHighlight({super.key, required this.highlights});

  @override
  ReviewImageVideoHighlightState createState() =>
      ReviewImageVideoHighlightState();
}

class ReviewImageVideoHighlightState extends State<ReviewImageVideoHighlight>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    _videoController = VideoPlayerController.networkUrl(Uri.parse(
        "https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4"))
      ..initialize().then((_) {
        setState(() {});
      });

    if (widget.highlights.isEmpty) return;

    final HighlightModel firstStory = widget.highlights.first;
    _loadStory(highlight: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.highlights.length) {
            _currentIndex += 1;
            _loadStory(highlight: widget.highlights[_currentIndex]);
          } else {
            _currentIndex = 0;
            _loadStory(highlight: widget.highlights[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HighlightModel highlight = widget.highlights[_currentIndex];
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details, highlight),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(
                  highlight.url,
                  cacheHeight: (18.h).cacheSize(context),
                ).image,
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Center(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.highlights.length,
              itemBuilder: (context, i) {
                final HighlightModel highlight = widget.highlights[i];
                switch (highlight.media) {
                  case MediaType.image:
                    return InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.4,
                      maxScale: 6,
                      child: CachedNetworkImage(
                        height: 40.h,
                        imageUrl: highlight.url,
                        memCacheHeight: (40.h).cacheSize(context),
                        imageBuilder: (context, imageProvider) {
                          _animController.forward();
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          if ((downloadProgress.progress != null) &&
                              downloadProgress.progress! >= 0 &&
                              downloadProgress.progress! < 1) {
                            _animController.stop();
                          } else {
                            _animController.forward();
                          }
                          _animController.stop();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: Colors.red,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Loading...",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.grey100,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          );
                        },
                        errorWidget: (context, url, error) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.loadImageError,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.grey100,
                                fontWeight: FontWeight.w300,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  case MediaType.video:
                    return Stack(
                      children: [
                        FutureBuilder(
                            future: VideoThumbnail.thumbnailData(
                              video: highlight.url,
                              imageFormat:
                                  ImageFormat.JPEG, // Specify image format
                              quality: 100, // Specify quality
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null) {
                                return Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: MemoryImage(snapshot.data!),
                                          fit: BoxFit.cover)),
                                );
                              } else {
                                return Container(
                                  height: 100.h,
                                  width: 100.w,
                                  color: Colors.transparent,
                                );
                              }
                            }),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 10),
                          child: Container(
                            height: 100.h,
                            width: 100.w,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                          width: 100.h,
                          child: _videoController.value.isInitialized
                              ? FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: _videoController.value.size.width,
                                    height: _videoController.value.size.height,
                                    child: VideoPlayer(_videoController),
                                  ),
                                )
                              : SizedBox(
                                  height: 100.h,
                                  width: 100.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .loadingOnlyText,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.grey100,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),

          //*  Bottom Animated Bar
          Positioned(
            top: 2.h,
            left: 2.w,
            right: 2.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.highlights
                  .asMap()
                  .map((i, e) {
                    return MapEntry(
                      i,
                      AnimatedBar(
                        position: i,
                        currentIndex: _currentIndex,
                        // animationController: _animController,
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ),

          //* Top Back button

          //* Top Add To Favorite Button  anf Share Button
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails details, HighlightModel highlight) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(highlight: widget.highlights[_currentIndex]);
        } else {
          _currentIndex = 0;
          _animController.stop();
          _animController.reset();
          _videoController.pause();
          _videoController.dispose();
          Navigator.of(context).pop();
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.highlights.length) {
          _currentIndex += 1;
          _loadStory(highlight: widget.highlights[_currentIndex]);
        } else {
          _currentIndex = 0;
          _animController.stop();
          _animController.reset();
          _videoController.pause();
          _videoController.dispose();
          Navigator.of(context).pop();
        }
      });
    } else {
      if (highlight.media == MediaType.video) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
          _animController.stop();
        } else {
          _videoController.play();
          _animController.forward();
        }
      }
    }
  }

  void _loadStory(
      {required HighlightModel highlight, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (highlight.media) {
      case MediaType.image:
        _animController.duration = highlight.duration;
        _animController.forward();
        break;
      case MediaType.video:
        _videoController.dispose();
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(highlight.url))
              ..initialize().then((_) {
                setState(() {});
                if (_videoController.value.isInitialized) {
                  _animController.duration = _videoController.value.duration;
                  _videoController.play();
                  _animController.forward();
                }
              });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
