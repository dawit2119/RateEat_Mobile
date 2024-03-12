import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';

class FoodItemShimmerCardVertical extends StatelessWidget {
  const FoodItemShimmerCardVertical({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return TextButton(
      onPressed: () {},
      child: Container(
        height: screenHeight * 0.23,
        width: screenWidth * 0.5,
        padding: EdgeInsets.only(
          top: screenHeight * 0.01,
          right: screenHeight * 0.01,
          left: screenHeight * 0.01,
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
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: screenHeight * 0.13,
              child: Stack(
                children: [
                  ShimmerContainer(
                    width: screenWidth * 0.48,
                    height: screenHeight * 0.11,
                  ),
                  Positioned(
                    top: screenHeight * 0.08,
                    left: screenWidth * 0.02,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
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
                Container(
                  height: 24,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    top: screenHeight * 0.005,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.18,
                        child: ShimmerContainer(
                          width: screenWidth * 0.22,
                          height: 24,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.011,
                      ),
                      const SizedBox(
                        // price
                        width: 40,
                        child: ShimmerContainer(
                          width: 30,
                          height: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const ShimmerContainer(
                  width: 100,
                  height: 15,
                ),
                const SizedBox(
                  height: 2,
                ),
                const ShimmerContainer(
                  width: 100,
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
