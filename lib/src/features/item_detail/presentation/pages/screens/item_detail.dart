import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/item_description.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/related_items.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/image_and_video_highlight.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/item_title.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/pages/restaurant_menu.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/item_review_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/item_review_shimmer_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/suggest_price_change.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/service/local_analytics.dart';
import '../../../../user_profile/presentation/pages/custom_tab_bar.dart';

class ItemDetail extends StatefulWidget {
  final String itemId;
  final ItemModel? item;
  final String? loginRedirection;
  final bool hasQuery;
  final VideoPlayerController? videoController;
  // ignore: prefer_const_constructors_in_immutables
  ItemDetail({
    super.key,
    required this.itemId,
    this.item,
    this.loginRedirection,
    this.hasQuery = false,
    this.videoController,
  });

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int reviewRetryCount = 0;
  int recommendationRetryCount = 0;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;

    return MultiBlocProvider(
      providers: [
        //* ----------------------------- Item Detail Bloc --------------------------------
        BlocProvider<ItemDetailBloc>(
          create: (context) => dpLocator<ItemDetailBloc>()
            ..add(GetItemDetailEvent(itemId: widget.itemId)),
        ),
        BlocProvider<PopularItemReviewsBloc>(
          create: (context) => dpLocator<PopularItemReviewsBloc>()
            ..add(GetPopularItemReviewsEvent(itemId: widget.itemId)),
        ),
        BlocProvider<DetailRecommendationBloc>(
          create: (context) => dpLocator<DetailRecommendationBloc>()
            ..add(GetRecommendedItemsEvent(
              itemId: widget.itemId,
            )),
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            if (widget.hasQuery || widget.loginRedirection != null) {
              context.goNamed(
                AppRoutes.home,
              );
            } else {
              context.pop();
            }
          }
        },
        child: Scaffold(
          body: item != null
              ? SingleChildScrollView(
                  child: Column(
                    key: Key("item_detail_rendered_from_parameter"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* Highlights
                      HorizontalHighlight(
                        fromRedirection: true,
                        videoController: widget.videoController,
                        item: item,
                        highlights: mapToHighlightModels(
                          item.itemImages.isEmpty
                              ? [
                                  ReviewMediaModel.fromMap(
                                      {'url': item.imageUrl})
                                ]
                              : item.itemImages.cast<ReviewMediaModel>(),
                          item.itemVideos,
                        ),
                        isFavorite: item.isFavorite,
                      ),
                      //* Item Detail Info
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.h),
                            ItemTitle(
                              item: item,
                              restaurantName:
                                  item.categories?.menu?.restaurant?.name ?? "",
                              currencyCode: "ETB",
                            ),
                            SizedBox(height: 1.h),
                            ItemDescription(
                                desc: item.description,
                                ingredients: item.ingredients),
                            SizedBox(height: 1.h),
                            Text(
                              AppLocalizations.of(context)!.popularReviewText,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF586069),
                              ),
                            ),
                            SizedBox(height: 1.h),

                            //* Popular Reviews
                            BlocBuilder<PopularItemReviewsBloc,
                                PopularItemReviewsState>(
                              builder: (context, state) {
                                if (state is PopularItemReviewLoading) {
                                  return const ReviewItemShimmerDisplay();
                                } else if (state is PopularItemReviewsLoaded) {
                                  final reviews = state.popularReviews.reviews;
                                  if (reviews.isEmpty) {
                                    return Column(
                                      key: const Key(
                                          "popular_review_is_empty_item_from_param"),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .firstReviewText,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                      ],
                                    );
                                  }
                                  return Column(
                                    key: const Key(
                                        "popular_review_loaded_and_not_empty_with_item_from_param"),
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: reviews.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            final currentReview =
                                                reviews[index];
                                            return ItemReviewsCard(
                                              item: widget.item!,
                                              userReview: currentReview,
                                            );
                                          }),
                                      if (item.numberOfReviews > reviews.length)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            SingleChip(
                                              selected: true,
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .seeText,
                                              onTap: () {
                                                context.pushNamed(
                                                  AppRoutes.itemReviews,
                                                  pathParameters: {
                                                    'itemId': item.itemId
                                                  },
                                                  extra: {
                                                    'item': item,
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      verticalPadding(height: 1),
                                    ],
                                  );
                                } else if (state is PopularItemReviewsFailure) {
                                  if (reviewRetryCount < 3) {
                                    reviewRetryCount++;
                                    context.read<PopularItemReviewsBloc>().add(
                                        GetPopularItemReviewsEvent(
                                            itemId: widget.itemId));
                                    return Container();
                                  } else {
                                    reviewRetryCount = 0;
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .noRevText,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          ElevatedButton(
                                            onPressed: () {
                                              context
                                                  .read<
                                                      PopularItemReviewsBloc>()
                                                  .add(
                                                      GetPopularItemReviewsEvent(
                                                          itemId:
                                                              widget.itemId));
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.red),
                                            ),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .retryText,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            ),

                            SizedBox(height: 2.h),

                            //* Recommendation
                            BlocBuilder<DetailRecommendationBloc,
                                DetailRecommendedState>(
                              builder: (context, state) {
                                if (state is DetailRecommendedLoading) {
                                  return const PopularItemsShimmerHorizontal();
                                } else if (state is DetailRecommendedSuccess) {
                                  final recommendations = state.recommendations;
                                  if (recommendations.isEmpty) {
                                    return Column(
                                      key: Key(
                                          'recommended_items_empty_when_item_passed_through_params'),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 2.h),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .noRecommendationsText,
                                          style: GoogleFonts.poppins(
                                            color: Colors.red,
                                            fontSize: 2.h,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                      ],
                                    );
                                  }
                                  return Column(
                                    key: Key(
                                        'recommended_items_not_empty_when_item_passed_through_params'),
                                    children: [
                                      RelatedItemsWidget(
                                        recommendations: recommendations,
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  );
                                } else if (state is DetailRecommendedError) {
                                  return Center(
                                    key: Key(
                                        'recommended_items_failed_when_item_passed_through_params'),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)!
                                              .errRecommendations,
                                          style: GoogleFonts.poppins(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<
                                                    DetailRecommendationBloc>()
                                                .add(GetRecommendedItemsEvent(
                                                    itemId: widget.itemId));
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.red),
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .retryText,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : BlocConsumer<ItemDetailBloc, ItemDetailState>(
                  key: UniqueKey(), // Ensure a unique key
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ItemDetailLoading) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: Center(
                          child: Column(
                            key: const Key(
                              'item_detail_loading',
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.dotsTriangle(
                                color: AppColors.primaryColor,
                                size: 6.h,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                AppLocalizations.of(context)!.itemDetailsText,
                                style: subTitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ItemDetailError) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: Center(
                          child: ErrorAndInfoDisplayWidget(
                            title:
                                AppLocalizations.of(context)!.unknownErrorText,
                            description:
                                AppLocalizations.of(context)!.tryAgainText,
                            assetImage: "assets/images/no_location_service.svg",
                            onPressed: () {
                              context.read<ItemDetailBloc>().add(
                                  GetItemDetailEvent(itemId: widget.itemId));
                              context.read<PopularItemReviewsBloc>().add(
                                  GetPopularItemReviewsEvent(
                                      itemId: widget.itemId));
                              context.read<DetailRecommendationBloc>().add(
                                    GetRecommendedItemsEvent(
                                      itemId: widget.itemId,
                                    ),
                                  );
                            },
                          ),
                        ),
                      );
                    } else if (state is ItemDetailSuccess) {
                      final Item item = state.item;
                      Future.delayed(Duration.zero, () {
                        if (context.mounted) {
                          context.read<UserReviewsPageCubit>().changePage(1);
                          context.read<PopularItemReviewsBloc>().add(
                                GetPopularItemReviewsEvent(itemId: item.itemId),
                              );
                        }
                        if (user != null && context.mounted) {
                          context.read<UserReviewBloc>().add(
                                GetUserReviewEvent(
                                  userId: user!.id!,
                                ),
                              );
                        }
                      });
                      //* add analytics for item detail
                      dpLocator<AnalyticsObserver>().sendAnalyticsEvent(
                          eventName: 'item_detail',
                          params: {
                            'item_id': item.itemId,
                            'item_name': item.itemName,
                            'item_price': item.price,
                            'item_image': item.imageUrl,
                            'item_rating': item.averageRating,
                          });
                      dpLocator<LocalAnalyticsObserver>()
                          .updateItemAnalytics(params: {
                        'item_id': item.itemId,
                        'item_name': item.itemName,
                      });

                      return CustomScrollView(
                        slivers: [
                          //* Highlights
                          SliverPersistentHeader(
                            delegate: CustomSliverItemAppBarDelegate(
                              expandedHeight: 40.h,
                              item: item,
                              videoPlayerController: widget.videoController,
                            ),
                            pinned: true,
                          ),
                          SliverToBoxAdapter(
                              child: buildItemInfo(item, context)),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
        ),
      ),
    );
  }

  Widget buildItemInfo(item, context) {
    return Column(
      key: const Key('item_detail_info'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.5.h),
              ItemTitle(
                item: item,
                restaurantName: item.categories?.menu?.restaurant?.name ?? "",
                currencyCode: AppLocalizations.of(context)!.birrText,
              ),
              SizedBox(
                height: 0.4.h,
              ),
              item.description == ""
                  ? Container()
                  : Text(
                      AppLocalizations.of(context)!.descriptionText,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600),
                    ),
              !(item.description != "")
                  ? SizedBox(
                      height: 1.5.h,
                    )
                  : Container(),
              item.description == ""
                  ? Container()
                  : Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.grey500,
                      ),
                    ),
              ((!(item.ingredients?.isEmpty ?? true)) && item.description != "")
                  ? SizedBox(height: 3.h)
                  : Container(),
              (item.ingredients?.isEmpty ?? true)
                  ? Container()
                  : Text(
                      AppLocalizations.of(context)!.ingredientText,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey600),
                    ),
              !(item.ingredients?.isEmpty ?? true)
                  ? SizedBox(height: 1.5.h)
                  : Container(),
              (item.ingredients?.isEmpty ?? true)
                  ? Container()
                  : Text(
                      item.ingredients!
                          .map((ing) => ing.name)
                          .toList()
                          .join(", "),
                      style: regular14.copyWith(color: AppColors.grey600)),
              SizedBox(height: 0.5.h),
              (!(item.ingredients?.isEmpty ?? true) || item.description != "")
                  ? const Divider(
                      color: AppColors.dividerColor,
                    )
                  : Container(),
              // SizedBox(height: 0.5.h),
              // SuggestPriceChange(
              //   isItem: true,
              //   item: item,
              // ),
              SizedBox(
                height: 0.5.h,
              ),
              const Divider(
                color: AppColors.dividerColor,
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: AddReview(
                  item: item,
                  isItem: true,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                AppLocalizations.of(context)!.userReviewText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF586069),
                ),
              ),
              SizedBox(height: 1.h),

              //* Popular Reviews
              BlocBuilder<PopularItemReviewsBloc, PopularItemReviewsState>(
                builder: (context, state) {
                  if (state is PopularItemReviewLoading) {
                    return const ReviewItemShimmerDisplay();
                  } else if (state is PopularItemReviewsLoaded) {
                    final reviews = state.popularReviews.reviews;
                    if (reviews.isEmpty) {
                      return Column(
                        key: const Key("popular_review_loaded_and_is_empty"),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.firstReviewText,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      );
                    }
                    return BlocConsumer<DeleteItemReviewBloc,
                        DeleteItemReviewState>(
                      listener: (context, state) {
                        if (state is DeleteItemReviewSuccess) {
                          showCustomToast(
                            context: context,
                            toastMessage: "Item ${state.message}",
                            toastType: ToastType.success,
                          );

                          //* Call to load the current Review
                          context.read<PopularItemReviewsBloc>().add(
                              GetPopularItemReviewsEvent(itemId: item.itemId));

                          if (user != null && context.mounted) {
                            context.read<UserReviewBloc>().add(
                                  GetUserReviewEvent(
                                    userId: user!.id!,
                                  ),
                                );
                          }
                        } else if (state is DeleteItemReviewFailure) {
                          showCustomToast(
                            context: context,
                            toastMessage: "Item ${state.message}",
                            toastType: ToastType.error,
                          );
                        } else {}
                      },
                      builder: (context, state) {
                        return Column(
                          key: Key("popular_review_loaded_and_not_empty"),
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: reviews.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final currentReview = reviews[index];
                                  return ItemReviewsCard(
                                    item: item,
                                    userReview: currentReview,
                                  );
                                }),
                            if (item.numberOfReviews > reviews.length)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  SingleChip(
                                    selected: true,
                                    title:
                                        AppLocalizations.of(context)!.seeText,
                                    onTap: () {
                                      context.pushNamed(
                                        AppRoutes.itemReviews,
                                        pathParameters: {'itemId': item.itemId},
                                        extra: {
                                          'item': item,
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is PopularItemReviewsFailure) {
                    if (reviewRetryCount < 3) {
                      reviewRetryCount++;
                      context.read<PopularItemReviewsBloc>().add(
                          GetPopularItemReviewsEvent(itemId: widget.itemId));
                      return Container();
                    } else {
                      reviewRetryCount = 0;
                      return Center(
                        child: Column(
                          key: const Key('item_detail_popular_reviews_failure'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.errorReviewText,
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<PopularItemReviewsBloc>().add(
                                    GetPopularItemReviewsEvent(
                                        itemId: widget.itemId));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.red),
                              ),
                              child: Text(
                                  AppLocalizations.of(context)!.retryText,
                                  style:
                                      GoogleFonts.poppins(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Container(
                    key: const Key('item_detail_popular_reviews_initial'),
                  );
                },
              ),

              SizedBox(height: 2.h),

              //* Recommendation
              BlocBuilder<DetailRecommendationBloc, DetailRecommendedState>(
                builder: (context, state) {
                  if (state is DetailRecommendedLoading) {
                    return const PopularItemsShimmerHorizontal();
                  } else if (state is DetailRecommendedSuccess) {
                    final recommendations = state.recommendations;
                    if (recommendations.isEmpty) {
                      return Column(
                        key: Key(
                            "item_detail_recommendations_loaded_and_is_empty"),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.h),
                          Text(
                            AppLocalizations.of(context)!.noRecommendationsText,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      );
                    }
                    return Column(
                      key: Key(
                          "item_detail_recommendations_loaded_and_not_empty"),
                      children: [
                        RelatedItemsWidget(
                          recommendations: recommendations,
                        ),
                        SizedBox(height: 2.h),
                      ],
                    );
                  } else if (state is DetailRecommendedError) {
                    return Center(
                      child: Column(
                        key: const Key('item_detail_recommended_items_failure'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.errRecommendations,
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<DetailRecommendationBloc>().add(
                                  GetRecommendedItemsEvent(
                                      itemId: widget.itemId));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.red),
                            ),
                            child: Text(AppLocalizations.of(context)!.retryText,
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    key: Key("initial_state_for_item_detail_recommendations"),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
