import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/user_engagement_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/highlight_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/highlight_animated_bar.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/rating_and_reviews.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/add_recommendation/add_recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/add_recommendation/add_recommendation_state.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../l10n/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HorizontalHighlight extends StatefulWidget {
  bool? isFavorite;
  bool isItem;
  ItemModel? item;
  RestaurantModel? restaurant;
  List<HighlightModel> highlights;
  VideoPlayerController? videoController;
  final bool fromRedirection;
  HorizontalHighlight({
    super.key,
    required this.highlights,
    this.isItem = true,
    this.restaurant,
    this.item,
    this.fromRedirection = false,
    this.isFavorite,
    this.videoController,
  });

  @override
  HighlightState createState() => HighlightState();
}

class HighlightState extends State<HorizontalHighlight>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoController;
  late TextEditingController _bottomSheetTextController;
  int _currentIndex = 0;
  bool isLoggedIn = false;
  bool isFavorite = false;

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() {
    isLoggedIn = getUser();
    isFavorite = widget.isFavorite ?? false;
    //*preload Images
    buildCachedImages(widget.highlights);
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    if (widget.videoController != null) {
      _videoController = widget.videoController!;
    } else {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(
            "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemReviewVideos/1702476041895.mp4"),
      )..initialize().then((_) {
          setState(() {
            isLoggedIn = getUser();
          });
        });
    }
    _bottomSheetTextController = TextEditingController(text: "");
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
    dpLocator<FavoriteBloc>().add(ResetFavorite());
    super.dispose();
  }

  static List<Widget> buildCachedImages(List<HighlightModel> highlights) {
    List<Widget> imageWidgets = [];

    for (var highlight in highlights) {
      if (highlight.media == MediaType.image) {
        imageWidgets.add(CachedNetworkImage(
          imageUrl: highlight.url,
          memCacheHeight: 100,
          memCacheWidth: 100,
        ));
      }
    }

    return imageWidgets;
  }

  static void deleteCachedImages(List<HighlightModel> highlights) {
    for (var highlight in highlights) {
      if (highlight.media == MediaType.image) {
        CachedNetworkImage.evictFromCache(highlight.url);
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    3.h,
                  ),
                  topRight: Radius.circular(
                    3.h,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      widget.item != null
                          ? AppLocalizations.of(context)!.recommendFoodText
                          : AppLocalizations.of(context)!
                              .recommendRestaurantText,
                      style: semiBold18,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.h),
                        border: Border.all(
                          width: 1.0,
                          color: AppColors.grey300,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1.h),
                        child: Row(
                          children: [
                            Container(
                              height: 8.h,
                              width: 8.h,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.isItem
                                      ? widget.item?.imageUrl ??
                                          "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"
                                      : (widget.restaurant!.restaurantImages !=
                                                  null &&
                                              widget.restaurant!
                                                  .restaurantImages!.isNotEmpty)
                                          ? widget.restaurant!
                                              .restaurantImages![0].url
                                          : "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
                                ),
                                borderRadius: BorderRadius.circular(2.h),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isItem
                                      ? widget.item!.itemName
                                      : widget.restaurant!.name!,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 0.3.h,
                                ),
                                RatingReviewWidget(
                                  rating: widget.isItem
                                      ? widget.item?.averageRating ?? 0.0
                                      : widget.restaurant!.averageRating ?? 0.0,
                                  noOfReviews: widget.isItem
                                      ? widget.item!.numberOfReviews
                                      : widget.restaurant!.numberOfReviews ?? 0,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.recommendationMessageText,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 3,
                      controller: _bottomSheetTextController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .writeYourReviewHereText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.h),
                          borderSide: const BorderSide(
                            width: 0.01,
                            color: AppColors.grey200,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    BlocConsumer<AddRecommendationBloc, AddRecommendationState>(
                      listener: (context, state) {
                        if (state is AddRecommendationSuccess) {
                          context
                              .read<AddRecommendationBloc>()
                              .add(ResetAddRecommendation());
                          context.pop();
                        }
                      },
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            final user = dpLocator<AuthenticationLocalSource>()
                                .getUserCredential();
                            if (user == null) {
                              _showLoginDialog(context,
                                  item: widget.item,
                                  restaurant: widget.restaurant);
                              return;
                            }
                            if (state is! AddRecommendationLoading) {
                              context.read<AddRecommendationBloc>().add(
                                    AddNewRecommendationEvent(
                                        isItem: widget.isItem,
                                        message:
                                            _bottomSheetTextController.text,
                                        restaurantId: !widget.isItem
                                            ? widget.restaurant!.id
                                            : null,
                                        itemId: widget.isItem
                                            ? widget.item!.itemId
                                            : null),
                                  );
                            }
                          },
                          child: Container(
                            height: 7.h,
                            decoration: BoxDecoration(
                                color: AppColors.primaryButtonColor,
                                borderRadius: BorderRadius.circular(2.h)),
                            child: Center(
                              child: state is AddRecommendationLoading
                                  ? LoadingAnimationWidget.dotsTriangle(
                                      color: Colors.white, size: 3.h)
                                  : Text(
                                      state is AddRecommendationFailed
                                          ? AppLocalizations.of(context)!
                                              .retryText
                                          : AppLocalizations.of(context)!
                                              .shareRecommendationText,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final HighlightModel highlight = widget.highlights[_currentIndex];
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details, highlight),
      child: Container(
        color: Colors.grey,
        height: 40.h,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              // physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) => {
                setState(() {
                  _currentIndex = value;
                })
              },
              itemCount: widget.highlights.length,
              itemBuilder: (context, i) {
                final HighlightModel highlight = widget.highlights[i];
                switch (highlight.media) {
                  case MediaType.image:
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // 1. The Main Food/Restaurant Image
                        CachedNetworkImage(
                          imageUrl: highlight.url,
                          memCacheHeight: (40.h).cacheSize(context),
                          fit: BoxFit.cover,
                          errorListener: (value) => {_animController.reset()},
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            if ((downloadProgress.progress != null) &&
                                downloadProgress.progress! >= 0 &&
                                downloadProgress.progress! < 1) {
                              _animController.stop();
                            } else {
                              _animController.forward();
                            }
                            return Container(
                              color: AppColors.grey200,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.red)),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),

                        // 2. The "Nice" Watermark (Glassmorphic Style)
                        Positioned(
                          left: -2.w,
                          bottom: 0.3.h, // Distance from left
                          child: ClipRRect(
                            // borderRadius:
                            //     BorderRadius.circular(30), // Rounded pill shape
                            child: BackdropFilter(
                              filter: ui.ImageFilter.blur(
                                  sigmaX: 5.0, sigmaY: 5.0), // Glass blur
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  //   color: AppColors.grey600.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      7,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // YOUR LOGO IMAGE
                                    Image.asset(
                                      'assets/images/splash_circle_removebg_preview.png', // Ensure this matches your file path
                                      height: 3.h, // Adjust size as needed
                                      fit: BoxFit.contain,
                                    ),
                                    //const SizedBox(width: 6),
                                    // BRAND TEXT
                                    // Text(
                                    //   "RateEat",
                                    //   style: GoogleFonts.poppins(
                                    //     color: Colors.white.withOpacity(0.95),
                                    //     fontWeight: FontWeight.w600,
                                    //     fontSize: 12,
                                    //     letterSpacing: 0.5,
                                    //     shadows: [
                                    //       const Shadow(
                                    //         blurRadius: 2.0,
                                    //         color: Colors.black45,
                                    //         offset: Offset(1.0, 1.0),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  case MediaType.video:
                    if (_videoController.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController.value.size.width,
                          height: _videoController.value.size.height,
                          child: VideoPlayer(_videoController),
                        ),
                      );
                    }
                }
                return const SizedBox.shrink();
              },
            ),

            //*  Bottom Animated Bar
            Positioned(
              bottom: 2.5.h,
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
                          // animationController: _animController,
                          position: i,
                          currentIndex: _currentIndex,
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),

            //* Bottom Right image page viewer
            Positioned(
              right: 5.w,
              bottom: 0.8.h,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey600.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      7,
                    ),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "${_currentIndex + 1}"),
                      const TextSpan(text: "/"),
                      TextSpan(
                        text: "${widget.highlights.length}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //* Top Back button
            Positioned(
              top: 2.h,
              left: 3.w,
              child: Container(
                height: 5.h,
                width: 5.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    shape: BoxShape.circle),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    deleteCachedImages(widget.highlights);
                    if (widget.fromRedirection) {
                      Navigator.of(context).pop();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 2.4.h,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
            ),

            //* Top Add To Favorite Button  anf Share Button
            Positioned(
              top: 2.h,
              right: 3.w,
              child: Row(
                children: [
                  // recommend button
                  Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [...elevation_4],
                        shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<AddRecommendationBloc>()
                            .add(ResetAddRecommendation());
                        _showBottomSheet(context);
                      },
                      child: Icon(
                        Iconsax.mirroring_screen,
                        size: 2.3.h,
                      ),
                    ),
                  ),

                  SizedBox(width: 2.5.w),

                  //* Share Button
                  Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [...elevation_4],
                        shape: BoxShape.circle),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Iconsax.export_1,
                        color: Colors.black,
                        size: 2.3.h,
                      ),
                      onPressed: () async {
                        if (widget.isItem) {
                          //* Update Item Share Analytics
                          dpLocator<AnalyticsObserver>().sendAnalyticsEvent(
                            eventName: 'item_share',
                            params: {
                              'item_id': widget.item!.itemId,
                              'item_name': widget.item!.itemName,
                            },
                          );
                          dpLocator<LocalAnalyticsObserver>()
                              .updateUserEngagementAnalytics(
                                  update:
                                      UserEngagementAnalytics(itemShare: 1));

                          dpLocator<LocalAnalyticsObserver>()
                              .updateItemShareAnalytics(params: {
                            'shared_item': widget.item!.itemId,
                          });

                          await shareContent(
                            imageUrl: widget.item!.imageUrl,
                            title: widget.item!.itemName,
                            link:
                                "https://rateeat.app/user/food-item/${widget.item!.itemId}?redirect=true",
                            ratings: widget.item!.averageRating,
                          );
                        } else {
                          //* Update Restaurant Share Analytics
                          dpLocator<AnalyticsObserver>().sendAnalyticsEvent(
                            eventName: 'restaurant_share',
                            params: {
                              'restaurant_id': widget.restaurant!.id,
                              'restaurant_name': widget.restaurant!.name,
                            },
                          );
                          dpLocator<LocalAnalyticsObserver>()
                              .updateUserEngagementAnalytics(
                            update: UserEngagementAnalytics(restaurantShare: 1),
                          );

                          dpLocator<LocalAnalyticsObserver>()
                              .updateRestaurantShareAnalytics(params: {
                            'shared_restaurant': widget.restaurant!.id,
                          });

                          await shareContent(
                            imageUrl: widget
                                    .restaurant!.restaurantImages!.isEmpty
                                ? 'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg'
                                : widget
                                    .restaurant!.restaurantImages!.first.url,
                            title: widget.restaurant!.name!,
                            link:
                                "https://rateeat.app/user/restaurant/${widget.restaurant!.id!}?redirect=true",
                            ratings: widget.restaurant!.averageRating!,
                            isItem: false,
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(width: 2.5.w),

                  //* Add to Favorite

                  Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [...elevation_4],
                        shape: BoxShape.circle),
                    child: BlocConsumer<FavoriteBloc, FavoriteState>(
                      listener: (context, state) {
                        if (state is FavoriteAdded) {
                          context.read<UserFavoriteBloc>().add(
                                GetUserFavoritesEvent(
                                  userId: user!.id!,
                                ),
                              );
                          showCustomToast(
                            context: context,
                            toastMessage:
                                AppLocalizations.of(context)!.favSuccessText,
                            toastType: ToastType.success,
                          );
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        } else if (state is FavoriteRemoved) {
                          context.read<UserFavoriteBloc>().add(
                                GetUserFavoritesEvent(
                                  userId: user!.id!,
                                ),
                              );
                          showCustomToast(
                            context: context,
                            toastMessage: AppLocalizations.of(context)!
                                .favSuccessRemoveText,
                            toastType: ToastType.success,
                          );
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        } else if (state is FavoriteFailed) {
                          showCustomToast(
                            context: context,
                            toastMessage: state.message!,
                            toastType: ToastType.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        Widget icon = IconButton(
                          tooltip: AppLocalizations.of(context)!.favoriteText,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                              isFavorite ? Iconsax.heart5 : Iconsax.heart,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 2.3.h),
                          onPressed: isLoggedIn
                              ? () {
                                  final favoriteBloc =
                                      context.read<FavoriteBloc>();
                                  if (isFavorite) {
                                    favoriteBloc.add(RemoveFromFavorite(
                                        itemId: widget.item?.itemId,
                                        restaurantId: widget.restaurant?.id));
                                  } else {
                                    favoriteBloc.add(
                                      AddToFavorite(
                                        itemId: widget.item?.itemId,
                                        restaurantId: widget.restaurant?.id,
                                      ),
                                    );
                                  }
                                }
                              : () {
                                  _showLoginDialog(
                                    context,
                                    item: widget.item,
                                    restaurant: widget.restaurant,
                                  );
                                },
                        );
                        if (state is FavoriteLoading) {
                          icon = IconButton(
                            tooltip: AppLocalizations.of(context)!.favoriteText,
                            padding: EdgeInsets.zero,
                            icon: Icon(Iconsax.heart,
                                color: Colors.grey, size: 2.5.h),
                            onPressed: () {},
                          );
                        }
                        return icon;
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//* Custom Share Dialog
  Future<void> shareContent({
    required String title,
    required String link,
    required double ratings,
    required String imageUrl,
    bool isItem = false, // false = restaurant, true = item
  }) async {
    try {
      final typeLabel = isItem ? "🍴 Dish" : "🏠 Restaurant";

      // Friendly, shareable message
      String content = '$typeLabel: $title\n'
          '⭐ Rating: ${ratings.toStringAsFixed(1)} / 5\n\n'
          '👉 Discover more on RateEat:\n$link';

      String? imagePath;

      try {
        // Try downloading the image
        Dio dio = Dio();
        final response = await dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        // Save image temporarily
        final tempDir = await getTemporaryDirectory();
        imagePath = '${tempDir.path}/share_item.jpg';
        File(imagePath).writeAsBytesSync(Uint8List.fromList(response.data));
      } catch (imgError) {
        debugPrint("⚠️ Image download failed: $imgError");
        imagePath = null; // fallback to text only
      }

      if (imagePath != null) {
        // Share with image + text
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: content,
        );
      } else {
        // Share text only
        await Share.share(content);
      }
    } catch (e) {
      debugPrint("❌ Share error: $e");
    }
  }

  void _showLoginDialog(BuildContext context,
      {ItemModel? item, RestaurantModel? restaurant}) {
    final loginRequiredText = AppLocalizations.of(context)!.loginRequiredText;
    final loginNeededText = AppLocalizations.of(context)!.loginNeededText;
    final cancelText = AppLocalizations.of(context)!.cancelText;
    final loginText = AppLocalizations.of(context)!.loginText;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(loginRequiredText),
          content: Text(loginNeededText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Close the dialog
              },
              child: Text(
                cancelText,
              ),
            ),
            TextButton(
              onPressed: () {
                if (item != null) {
                  var routeInfo = {
                    "routeName": AppRoutes.itemDetail,
                    "item": item,
                  };
                  Navigator.of(ctx).pop(); // Close the dialog
                  context.pushNamed(
                    AppRoutes.login,
                    extra: routeInfo,
                  ); // Navigate to login screen
                } else {
                  var routeInfo = {
                    "routeName": AppRoutes.restaurantDetail,
                    "restaurant": restaurant,
                  };
                  Navigator.of(ctx).pop(); // Close the dialog
                  context.pushNamed(
                    AppRoutes.login,
                    extra: routeInfo,
                  ); // Navigate to login screen
                }
              },
              child: Text(
                loginText,
              ),
            ),
          ],
        );
      },
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
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.highlights.length) {
          _currentIndex += 1;
          _loadStory(highlight: widget.highlights[_currentIndex]);
        } else {
          _currentIndex = 0;
          _loadStory(highlight: widget.highlights[_currentIndex]);
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
              ..initialize().then(
                (_) {
                  if (_videoController.value.isInitialized) {
                    _animController.duration = _videoController.value.duration;
                    _videoController.play();
                    _videoController.setVolume(0.0);
                    _animController.forward(from: 0.0);
                    setState(() {});
                  }
                },
                onError: (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.cantLoadVideoText,
                        ),
                      ),
                    );
                  }
                },
              );

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
