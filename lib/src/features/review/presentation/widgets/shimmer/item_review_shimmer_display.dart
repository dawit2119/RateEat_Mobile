import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/core.dart';
import './item_review_card_shimmer.dart';

class ReviewItemShimmerDisplay extends StatelessWidget {
  final int shimmerCount;
  const ReviewItemShimmerDisplay({
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
          (index) => const ItemReviewCardShimmer(),
        ),
      ),
    );
  }
}
