import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/shimmer_container.dart';

class RestaurantCardShimmer extends StatelessWidget {
  const RestaurantCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 25),
      child: Container(
        height: screenHeight * 0.17,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.transparent,
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
              blurRadius: 10,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.12,
                  left: screenWidth * 0.7,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3F3F3F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: ShimmerContainer(
                        width: 50,
                        height: 16,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ShimmerContainer(
                            width: screenWidth * .3,
                            height: 20,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: ShimmerContainer(width: 30, height: 18),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const ShimmerContainer(
                          width: 15,
                          height: 15,
                          horizontalMargin: 5,
                        ),
                        ShimmerContainer(width: screenWidth * .3, height: 15)
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShimmerContainer(
                                width: screenWidth * 0.2,
                                height: 10,
                                horizontalMargin: 2,
                              ),
                              ShimmerContainer(
                                width: screenWidth * 0.2,
                                height: 10,
                                horizontalMargin: 2,
                              ),
                              ShimmerContainer(
                                width: screenWidth * 0.2,
                                height: 10,
                                horizontalMargin: 2,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ShimmerContainer(
                                  width: screenWidth * .2,
                                  height: 10,
                                ),
                                ShimmerContainer(
                                  width: screenWidth * .2,
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
