import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../../review/presentation/widgets/textfield_input.dart';
import '../bloc/food_review/food_review_bloc.dart';
import '../bloc/food_review/food_review_event.dart';
import '../bloc/food_review/food_review_state.dart';
import '../bloc/share_media/share_media_bloc.dart';
import '../bloc/share_media/share_media_state.dart';

class GiveFoodReview extends StatefulWidget {
  const GiveFoodReview({super.key, required this.foodId});

  final String foodId;

  @override
  State<GiveFoodReview> createState() => _GiveFoodReviewState();
}

class _GiveFoodReviewState extends State<GiveFoodReview> {
  final TextEditingController reviewTextController = TextEditingController();
  double rating = 4;

  @override
  void initState() {
    super.initState();
    context
        .read<ItemDetailBloc>()
        .add(GetItemDetailEvent(itemId: widget.foodId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodReviewBloc, FoodReviewState>(
      listener: (context, foodReviewState) {
        if (foodReviewState.status == FoodReviewStatus.error) {
          showCustomToast(
            context: context,
            toastMessage: foodReviewState.errorMessage,
            toastType: ToastType.error,
          );
        } else if (foodReviewState.status == FoodReviewStatus.success) {
          context.pop();
          context.goNamed(
            AppRoutes.itemDetail,
            pathParameters: {'itemId': widget.foodId},
          );
        }
      },
      builder: (context, foodReviewState) {
        return Scaffold(
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
              isLoading: foodReviewState.status == FoodReviewStatus.loading,
              buttonText: "Share Review",
              onPressed: () {
                context.read<FoodReviewBloc>().add(
                      SubmitFoodReview(
                        foodId: widget.foodId,
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
                      BlocBuilder<ItemDetailBloc, ItemDetailState>(
                          builder: (context, foodInfoState) {
                        if (foodInfoState is ItemDetailLoading) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                        } else if (foodInfoState is ItemDetailSuccess) {
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
                                      imageUrl: (foodInfoState
                                                      .item.itemImages !=
                                                  null &&
                                              foodInfoState
                                                  .item.itemImages!.isNotEmpty)
                                          ? foodInfoState
                                              .item.itemImages![0].url
                                          : "https://cdn-icons-png.freepik.com/256/4416/4416884.png?uid=R17639002&ga=GA1.1.267151208.1716376357&semt=ais_hybrid",
                                    ),
                                  ),
                                ),
                                horizontalPadding(width: 1.2),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodInfoState.item.itemName,
                                        style: semiBold18.copyWith(
                                            color: AppColors.grey700),
                                      ),
                                      verticalPadding(height: .6),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Iconsax.star1,
                                                color: AppColors.primaryColor,
                                              ),
                                              horizontalPadding(width: .5),
                                              Text(
                                                foodInfoState.item.averageRating
                                                    .toString(),
                                                style: medium16.copyWith(
                                                    color: AppColors.grey500),
                                              ),
                                            ],
                                          ),
                                          horizontalPadding(width: .8),
                                          Container(
                                            height: 4,
                                            width: 4,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.grey200,
                                            ),
                                          ),
                                          horizontalPadding(width: .8),
                                          Text(
                                            "${foodInfoState.item.numberOfReviews} reviews",
                                            style: regular16.copyWith(
                                                color: AppColors.grey500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (foodInfoState is ItemDetailError) {
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
                                  'Failed to food details',
                                  style: medium16,
                                ),
                                verticalPadding(height: 1),
                                CustomTextButton(
                                  title: "Try Again",
                                  ontap: () {
                                    context.read<ItemDetailBloc>().add(
                                          GetItemDetailEvent(
                                            itemId: widget.foodId,
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
                                context.read<ItemDetailBloc>().add(
                                      GetItemDetailEvent(
                                        itemId: widget.foodId,
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
                            "How is the food?",
                            style: bold20,
                          ),
                          verticalPadding(height: .5),
                          Text(
                            "Take a moment to rate your experience with this food.",
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
        );
      },
    );
  }
}
