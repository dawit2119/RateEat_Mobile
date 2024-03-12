import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class RestaurantReviewShimmerCard extends StatelessWidget {
  const RestaurantReviewShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const ShimmerContainer(
              width: 35,
              height: 35,
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
                            width: screenWidth * 0.25,
                            height: 10,
                          ),
                          const ShimmerContainer(
                            width: 40,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    ShimmerContainer(
                      width: screenWidth * .2,
                      height: 10,
                    )
                  ],
                ),
                // *Comment Section
                ShimmerContainer(
                  width: screenWidth * .33,
                  height: 10,
                ),

                // *Images Section
                ShimmerContainer(
                  width: screenWidth * .2,
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                verticalPadding(
                  height: .3,
                ),
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
