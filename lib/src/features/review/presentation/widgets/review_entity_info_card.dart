import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../homepage/domain/entities/item.dart';
import '../../../map_section/data/models/restaurant_model.dart';

class ReviewEntityInfoCard extends StatelessWidget {
  final Item? item;
  final RestaurantModel? restaurant;
  const ReviewEntityInfoCard({super.key, this.item, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 12.h,
            height: 12.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item != null
                    ? item!.imageUrl.toString()
                    : (restaurant?.restaurantImages?.isEmpty ?? true)
                        ? "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740"
                        : restaurant!.restaurantImages!.first.url,
                memCacheHeight: (12.h).cacheSize(context),
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
          ),
          horizontalPadding(width: 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalPadding(height: 1),
                Text(
                  (item != null)
                      ? item!.itemName
                      : (restaurant != null && restaurant!.name != null)
                          ? restaurant!.name!
                          : "Item/Restaurant name",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: medium16,
                ),
                verticalPadding(height: 1),
                Row(
                  children: [
                    const Icon(
                      Iconsax.star1,
                      color: AppColors.primaryColor,
                    ),
                    horizontalPadding(width: 1),
                    Text(
                      (item != null)
                          ? item!.averageRating.toString()
                          : (restaurant != null)
                              ? restaurant!.averageRating.toString()
                              : "0.0",
                      style: regular14,
                    ),
                    horizontalPadding(width: .8),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grey300,
                      ),
                    ),
                    horizontalPadding(width: .8),
                    // ? number of reviews widget
                    Text(
                      (item != null)
                          ? "${item!.numberOfReviews.toString()} reviews"
                          : (restaurant != null)
                              ? "${restaurant!.numberOfReviews.toString()} reviews"
                              : "No reviews",
                      style: regular14,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
