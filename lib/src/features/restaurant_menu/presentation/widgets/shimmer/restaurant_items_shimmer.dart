import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import 'menu_favorite_card_shimmer.dart';

class RestaurantMenuItemsShimmer extends StatelessWidget {
  const RestaurantMenuItemsShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerContainer(
                width: 28.w,
                height: 3.h,
                horizontalMargin: 5,
              ),
              ShimmerContainer(
                width: 25.w,
                height: 3.h,
                horizontalMargin: 5,
              ),
              ShimmerContainer(
                width: 25.h,
                height: 3.h,
                horizontalMargin: 5,
              ),
            ],
          ),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return const MenuFavoriteCardShimmer();
            },
            itemCount: 4,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3, // adjust this as needed
            ),
            itemBuilder: (BuildContext context, int index) {
              return const MenuFavoriteCardShimmer();
            },
            itemCount: 4,
          ),
        ],
      ),
    );
  }
}
