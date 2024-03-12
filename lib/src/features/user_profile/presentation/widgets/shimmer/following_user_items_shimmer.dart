import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/following_user_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/core.dart';

class FollowingUserItemsShimmer extends StatelessWidget {
  final int shimmerCount;
  const FollowingUserItemsShimmer({
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
            (index) => const FollowingUserCardShimmer(),
          ),
        ),
      ),
    );
  }
}
