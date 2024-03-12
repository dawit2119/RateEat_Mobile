import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/item_search_result_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class ItemSearchResultsShimmer extends StatelessWidget {
  final int shimmerCount;
  const ItemSearchResultsShimmer({
    super.key,
    this.shimmerCount = 6, // Updated to fit a grid with an even count
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.85,
          ),
          itemCount: shimmerCount,
          itemBuilder: (context, index) {
            return const ItemSearchResultCardShimmer(); // Replace with shimmer card widget
          },
        ),
      ),
    );
  }
}
