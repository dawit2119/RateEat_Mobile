import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:shimmer/shimmer.dart';

import 'user_favorite_card_shimmer.dart';

class UserFavoriteItemsShimmer extends StatelessWidget {
  final int shimmerCount;
  const UserFavoriteItemsShimmer({
    super.key,
    this.shimmerCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: GridView.builder(
          itemCount: shimmerCount,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (BuildContext context, int index) =>
              const UserFavoriteCardShimmer(),
        ),
      ),
    );
  }
}
