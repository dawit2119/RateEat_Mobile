import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';

class PromotionBoardShimmerCard extends StatelessWidget {
  const PromotionBoardShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: screenWidth * 0.5,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 157,
                      height: 27,
                    ),
                    ShimmerContainer(
                      width: 99,
                      height: 18,
                    ),
                    ShimmerContainer(
                      width: 50,
                      height: 18,
                    ),
                    ShimmerContainer(
                      width: 76,
                      height: 22,
                      child: ShimmerContainer(
                        width: 44,
                        height: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ShimmerContainer(
                width: 100,
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
