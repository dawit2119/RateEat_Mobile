import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class UserFavoriteCardShimmer extends StatelessWidget {
  const UserFavoriteCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 2,
              child: ShimmerContainer(
                width: screenWidth * 0.3,
                height: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ShimmerContainer(
                    width: screenWidth * .25,
                    height: 30,
                  ),
                ),
                verticalPadding(height: .1),
                ShimmerContainer(
                  width: screenWidth * .3,
                  height: 12,
                ),
                verticalPadding(height: .1),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ShimmerContainer(
                      width: 20,
                      height: 15,
                    ),
                    const ShimmerContainer(
                      width: 40,
                      height: 12,
                      horizontalMargin: 2,
                    ),
                    horizontalPadding(width: 1),
                    const Expanded(
                      child: ShimmerContainer(
                        width: 40,
                        height: 12,
                      ),
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
