import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ItemAndRestaurantResultsShimmer extends StatelessWidget {
  final int shimmerCount;
  const ItemAndRestaurantResultsShimmer(
      {super.key, required this.shimmerCount});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          shimmerCount,
          (_) => Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 5.h,
                    width: 60.w,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 5.h,
                    width: 7.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
