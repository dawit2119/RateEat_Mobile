import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/recommended_item_card_shimmer.dart';

import 'package:shimmer/shimmer.dart';

class RecommendedItemsShimmer extends StatelessWidget {
  final int shimmerCount;
  const RecommendedItemsShimmer({
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
          (index) => const RecommendedItemCardShimmer(),
        ),
      ),
    );
  }
}
