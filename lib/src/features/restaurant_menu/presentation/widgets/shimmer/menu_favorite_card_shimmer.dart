import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class MenuFavoriteCardShimmer extends StatelessWidget {
  const MenuFavoriteCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
            height: 127,
            width: screenWidth * .4,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerContainer(width: 60, height: 12),
                      Spacer(),
                      ShimmerContainer(width: 60, height: 12),
                    ],
                  ),
                  ShimmerContainer(width: 40, height: 14),
                  ShimmerContainer(
                    width: 90,
                    height: 14,
                  ),
                  ShimmerContainer(
                    width: 70,
                    height: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
