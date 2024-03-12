import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/restaurant_search_result_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantResultsShimmer extends StatelessWidget {
  final int shimmerCount;
  const RestaurantResultsShimmer({
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
            (index) => const RestaurantCardShimmer(),
          ),
        ),
      ),
    );
  }
}
