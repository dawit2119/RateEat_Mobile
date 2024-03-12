import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/restaurant_review_shimmer_card.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantShimmerDisplay extends StatelessWidget {
  final int shimmerCount;
  const RestaurantShimmerDisplay({
    super.key,
    this.shimmerCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: List.generate(
          shimmerCount,
          (index) => const RestaurantReviewShimmerCard(),
        ),
      ),
    );
  }
}
