import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/promotion_board_shimmer_card.dart';
import 'package:shimmer/shimmer.dart';

class PromotionBoardShimmer extends StatelessWidget {
  const PromotionBoardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: const Row(
          children: [
            PromotionBoardShimmerCard(),
            PromotionBoardShimmerCard(),
          ],
        ),
      ),
    );
  }
}
