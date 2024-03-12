import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_event.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/presentation/bloc/restaurant_review/restaurant_review_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_state.dart';
import '../../../review/presentation/widgets/textfield_input.dart';
import '../bloc/restaurant_review/restaurant_review_bloc.dart';
import '../bloc/restaurant_review/restaurant_review_event.dart';
import '../bloc/share_media/share_media_bloc.dart';
import '../bloc/share_media/share_media_state.dart';

class GiveRestaurantReview extends StatefulWidget {
  const GiveRestaurantReview({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<GiveRestaurantReview> createState() => _GiveRestaurantReviewState();
}

class _GiveRestaurantReviewState extends State<GiveRestaurantReview> {
  final TextEditingController reviewTextController = TextEditingController();
  double rating = 4;
  RestaurantReviewBloc restaurantReviewBloc =
      dpLocator.get<RestaurantReviewBloc>();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailBloc>().add(
          GetRestaurantDetailEvent(restaurantId: widget.restaurantId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantReviewBloc, RestaurantReviewState>(
      bloc: restaurantReviewBloc,
      listener: (context, restaurantReviewState) {
        if (restaurantReviewState.status == RestaurantReviewStatus.error) {
          showCustomToast(
            context: context,
            toastMessage: restaurantReviewState.errorMessage,
            toastType: ToastType.error,
          );
        } else if (restaurantReviewState.status ==
            RestaurantReviewStatus.success) {
          context.pop();
          context.goNamed(
            AppRoutes.restaurantDetail,
            pathParameters: {'restaurantId': widget.restaurantId},
          );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: CustomAppBar(
          onTap: () => context.pop(),
          title: 'Write a Review',
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: DefaultButton(
            buttonText: restaurantReviewBloc.state.status ==
                    RestaurantReviewStatus.loading
                ? "Sharing review..."
                : "Share Review",
            onPressed: () {
              restaurantReviewBloc.add(
                SubmitRestaurantReview(
                  restaurantId: widget.restaurantId,
                  reviewMessage: reviewTextController.text,
                  rating: rating,
                  reviewMedia: context
                      .read<SharedMediaBloc>()
                      .state
                      .sharedFiles!
                      .map((e) => File(e.path))
                      .toList(),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalPadding(height: 4),
                    BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
                        builder: (context, restaurantInfoState) {
                      if (restaurantInfoState is RestaurantDetailLoading) {
                        return Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                horizontalPadding(width: 1.2),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                      ),
                                      verticalPadding(height: 1.5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                          horizontalPadding(width: .8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 6,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                verticalPadding(height: .8),
                                                Container(
                                                  height: 6,
                                                  width: 20.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (restaurantInfoState
                          is RestaurantDetailSuccess) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey200),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: (restaurantInfoState.restaurant
                                                    .restaurantImages !=
                                                null &&
                                            restaurantInfoState.restaurant
                                                .restaurantImages!.isNotEmpty)
                                        ? restaurantInfoState
                                            .restaurant.restaurantImages![0].url
                                        : "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740",
                                  ),
                                ),
                              ),
                              horizontalPadding(width: 1.2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurantInfoState.restaurant.name!,
                                      style: semiBold18.copyWith(
                                          color: AppColors.grey700),
                                    ),
                                    verticalPadding(height: .8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Iconsax.location,
                                          color: AppColors.grey500,
                                        ),
                                        horizontalPadding(width: .8),
                                        Expanded(
                                          child: Text(
                                            restaurantInfoState
                                                .restaurant
                                                .restaurantLocations![0]
                                                .description!,
                                            style: regular16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (restaurantInfoState is RestaurantDetailError) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to restaurant details',
                                style: medium16,
                              ),
                              verticalPadding(height: 1),
                              CustomTextButton(
                                title: "Try Again",
                                ontap: () {
                                  context.read<RestaurantDetailBloc>().add(
                                        GetRestaurantDetailEvent(
                                          restaurantId: widget.restaurantId,
                                        ),
                                      );
                                },
                              ),
                              verticalPadding(height: 1),
                              const Divider(
                                color: AppColors.grey100,
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Image.asset("assets/images/Error_page.png"),
                          Text(
                            "Bad state",
                            style: semiBold16,
                          ),
                          verticalPadding(height: 1),
                          Text(
                            "Please retry again. If the problem stays try updating your app version",
                            style: medium14,
                          ),
                          verticalPadding(height: 2),
                          CustomTextButton(
                            title: "Try Again",
                            ontap: () {
                              context.read<RestaurantDetailBloc>().add(
                                    GetRestaurantDetailEvent(
                                      restaurantId: widget.restaurantId,
                                    ),
                                  );
                            },
                          ),
                        ],
                      );
                    }),
                    verticalPadding(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How is the restaurant?",
                          style: bold20,
                        ),
                        verticalPadding(height: .5),
                        Text(
                          "Rate the restaurant based on your experience",
                          style: regular16,
                        ),
                      ],
                    ),
                    verticalPadding(height: 1.2),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      glow: false,
                      glowColor: AppColors.grey100,
                      glowRadius: 0.1,
                      direction: Axis.horizontal,
                      onRatingUpdate: (rating) {
                        this.rating = rating;
                      },
                      allowHalfRating: false,
                      itemCount: 5,
                      unratedColor: AppColors.grey200,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, _) => const Icon(
                        Iconsax.star1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    verticalPadding(height: 3),
                    InputTextfield(
                      title: "Add a review",
                      textEditingController: reviewTextController,
                    ),
                    verticalPadding(height: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Uploaded Images",
                          style: medium18,
                        ),
                        verticalPadding(height: 1),
                        BlocBuilder<SharedMediaBloc, SharedMediaState>(
                            builder: (context, sharedMediaState) {
                          return SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                ...List.generate(
                                  sharedMediaState.sharedFiles!.length,
                                  (index) => Positioned(
                                    left: 40 * index.toDouble(),
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 34,
                                        foregroundColor: AppColors.grey100,
                                        backgroundColor: AppColors.grey100,
                                        backgroundImage: FileImage(
                                          File(sharedMediaState
                                              .sharedFiles![index].path),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
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
