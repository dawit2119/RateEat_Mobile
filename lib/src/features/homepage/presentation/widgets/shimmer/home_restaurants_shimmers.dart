import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/home_restaurant_shimmer_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeRestaurantsShimmers extends StatelessWidget {
  final int shimmerCount;
  const HomeRestaurantsShimmers({super.key, this.shimmerCount = 3});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: List.generate(
          shimmerCount,
          (index) => const ShimmerHomeRestaurantCard(),
        ),
      ),
    );
  }
}
