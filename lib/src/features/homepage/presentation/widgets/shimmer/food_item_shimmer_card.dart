import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';

class FoodItemShimmerCard extends StatelessWidget {
  const FoodItemShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: screenHeight * 0.2,
        width: screenWidth * 0.5,
        padding: EdgeInsets.only(
          top: screenHeight * 0.01,
          right: screenHeight * 0.01,
          left: screenHeight * 0.01,
          bottom: 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.10,
              child: Stack(
                children: [
                  ShimmerContainer(
                    width: screenWidth * 0.48,
                    height: screenHeight * 0.095,
                  ),
                  Positioned(
                    top: screenHeight * 0.07,
                    left: screenWidth * 0.026,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const ShimmerContainer(
                        width: 48,
                        height: 24,
                        borderRadius: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.29,
                      child: ShimmerContainer(
                        width: screenWidth * 0.29,
                        height: 17,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.011,
                    ),
                    const SizedBox(
                      // price
                      width: 40,
                      child: ShimmerContainer(
                        width: 40,
                        height: 17,
                      ),
                    ),
                  ],
                ),
                const ShimmerContainer(
                  width: 100,
                  height: 17,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
