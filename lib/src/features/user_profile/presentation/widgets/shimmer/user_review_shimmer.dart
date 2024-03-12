import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/core.dart';
import 'user_review_card_shimmer.dart';

class UserReviewShimmerDisplay extends StatelessWidget {
  final int shimmerCount;
  const UserReviewShimmerDisplay({
    super.key,
    this.shimmerCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            shimmerCount,
            (index) => const UserReviewCardShimmer(),
          ),
        ),
      ),
    );
  }
}
