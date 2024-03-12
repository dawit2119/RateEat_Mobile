import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_recommendation_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/core.dart';

class UserRecommendationItemsShimmer extends StatelessWidget {
  final int shimmerCount;
  const UserRecommendationItemsShimmer({
    super.key,
    this.shimmerCount = 3,
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
            (index) => const UserRecommendationCardShimmer(),
          ),
        ),
      ),
    );
  }
}
