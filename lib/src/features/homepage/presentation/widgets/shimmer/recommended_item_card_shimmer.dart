import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';

class RecommendedItemCardShimmer extends StatelessWidget {
  const RecommendedItemCardShimmer({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.32,
      width: screenWidth,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
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
          ShimmerContainer(
            height: screenHeight * 0.16,
            width: screenWidth,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.6,
                padding: EdgeInsets.only(
                    left: screenWidth * 0.02, right: screenWidth * 0.1),
                child: ShimmerContainer(
                  width: screenWidth * 0.6,
                  height: 30,
                ),
              ),
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ShimmerContainer(
                      width: screenWidth * 0.1,
                      height: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) => ShimmerContainer(
                          width: screenWidth * 0.24,
                          height: 12,
                          horizontalMargin: 2,
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        ShimmerContainer(
                          width: 40,
                          height: 14,
                          horizontalMargin: 2,
                        ),
                        ShimmerContainer(
                          width: 60,
                          height: 14,
                        ),
                        ShimmerContainer(
                          width: 50,
                          height: 14,
                          horizontalMargin: 2,
                        ),
                        ShimmerContainer(
                          width: 100,
                          height: 14,
                          horizontalMargin: 2,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
