import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class UserReviewCardShimmer extends StatelessWidget {
  const UserReviewCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const ShimmerContainer(
                height: 35,
                width: 35,
              ),
            ),
          ),
          horizontalPadding(width: 2),
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
                            height: 10,
                          ),
                          ShimmerContainer(
                            width: screenWidth * .22,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    ShimmerContainer(
                      width: screenWidth * .33,
                      height: 10,
                    ),
                  ],
                ),
                verticalPadding(height: 1),
                ShimmerContainer(
                  width: screenWidth * .30,
                  height: 10,
                ),
                ShimmerContainer(
                  width: screenWidth * .35,
                  height: 30,
                ),
                verticalPadding(height: .4),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                verticalPadding(height: 1),
                Row(
                  children: [
                    const ShimmerContainer(
                      width: 30,
                      height: 25,
                      borderRadius: 10,
                    ),
                    horizontalPadding(width: 1),
                    const ShimmerContainer(
                      width: 25,
                      height: 15,
                      borderRadius: 5,
                    ),
                    horizontalPadding(width: 3),
                    const ShimmerContainer(
                      width: 30,
                      height: 25,
                      borderRadius: 10,
                    ),
                    horizontalPadding(width: 1),
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
