import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/constants.dart';
import 'discover_restaurant_item_result_shimmer.dart';
import './go_to_all_menus_shimmer.dart';

class DishesShimmer extends StatelessWidget {
  const DishesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            3,
            (index) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: const DiscoverResultItemShimmer(),
            ),
          ),
          const GotoAllMenusShimmerCard(),
        ],
      ),
    );
  }
}
