import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemReviewCardShimmer extends StatelessWidget {
  const ItemReviewCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerContainer(
            width: 35,
            height: 35,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerContainer(
                            width: screenWidth * .25,
                            height: 12,
                          ),
                          const ShimmerContainer(
                            width: 40,
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    ShimmerContainer(
                      width: screenWidth * .25,
                      height: 12,
                    ),
                  ],
                ),
                ShimmerContainer(
                  width: screenWidth * .3,
                  height: 12,
                ),
                ShimmerContainer(
                  width: screenWidth * .38,
                  height: 30,
                  borderRadius: 10,
                ),
                SizedBox(height: .6.h),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    const ShimmerContainer(
                      width: 30,
                      height: 25,
                      borderRadius: 10,
                    ),
                    SizedBox(width: 1.w),
                    const ShimmerContainer(
                      width: 25,
                      height: 15,
                      borderRadius: 5,
                    ),
                    SizedBox(width: 3.w),
                    const ShimmerContainer(
                      width: 30,
                      height: 25,
                      borderRadius: 10,
                    ),
                    SizedBox(width: 1.w),
                    const ShimmerContainer(
                      width: 25,
                      height: 15,
                      borderRadius: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
