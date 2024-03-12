import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class TagShimmer extends StatelessWidget {
  const TagShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            child: ShimmerContainer(
                width: screenWidth * 0.15, height: screenHeight * 0.03)),
      ),
    );
  }
}
