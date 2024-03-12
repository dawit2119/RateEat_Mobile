import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';

class DiscoverResultItemShimmer extends StatelessWidget {
  const DiscoverResultItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
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
          color: Colors.white10,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.12,
              child: ShimmerContainer(
                width: screenWidth * 0.48,
                height: screenHeight * 0.10,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ShimmerContainer(
                            width: screenWidth * 0.29,
                            height: 18,
                          ),
                        ),
                        horizontalPadding(width: 3),
                        const Expanded(
                          // price
                          child: ShimmerContainer(
                            width: 40,
                            height: 16,
                          ),
                        ),
                      ],
                    ),
                    const Wrap(
                      alignment: WrapAlignment.start,
                      clipBehavior: Clip.hardEdge,
                      spacing: 4,
                      children: [
                        ShimmerContainer(
                          width: 30,
                          height: 16,
                        ),
                        ShimmerContainer(
                          width: 30,
                          height: 16,
                        ),
                        ShimmerContainer(
                          width: 30,
                          height: 16,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const ShimmerContainer(
                      width: double.infinity,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
