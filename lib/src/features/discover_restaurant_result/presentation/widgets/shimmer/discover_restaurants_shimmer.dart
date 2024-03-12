import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/constants.dart';
import './dishes_shimmer.dart';
import './restaurant_card_shimmer.dart';

class DiscoverRestaurantResultsShimmer extends StatelessWidget {
  final int shimmerCount;
  const DiscoverRestaurantResultsShimmer({
    super.key,
    this.shimmerCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: List.generate(
          shimmerCount,
          (index) => const Column(
            children: [
              RestaurantShimmerCard(),
              DishesShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}
