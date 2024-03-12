import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/food_item_shimmer_card.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/food_item_shimmer_vertical_card.dart';
import 'package:shimmer/shimmer.dart';

class PopularItemsShimmerHorizontal extends StatelessWidget {
  final int shimmerCount;
  const PopularItemsShimmerHorizontal({super.key, this.shimmerCount = 2});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            shimmerCount,
            (index) => const Padding(
              padding: EdgeInsets.only(right: 12),
              child: FoodItemShimmerCard(),
            ),
          ),
        ),
      ),
    );
  }
}

class PopularItemsShimmerVertical extends StatelessWidget {
  final int shimmerCount;

  const PopularItemsShimmerVertical({
    super.key,
    this.shimmerCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (BuildContext context, int index) =>
                const FoodItemShimmerCardVertical(),
            itemCount: shimmerCount,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
