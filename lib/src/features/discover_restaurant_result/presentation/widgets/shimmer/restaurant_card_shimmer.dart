import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class RestaurantShimmerCard extends StatelessWidget {
  const RestaurantShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Positioned(
                bottom: -5,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.textDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const ShimmerContainer(
                    width: 60,
                    height: 20,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerContainer(
                        width: screenHeight * .2,
                        height: 25,
                        horizontalMargin: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: ShimmerContainer(
                          horizontalMargin: 5,
                          width: screenHeight * .09,
                          height: 25,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const ShimmerContainer(
                        width: 20,
                        height: 15,
                        horizontalMargin: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: ShimmerContainer(
                          width: screenWidth * 0.3,
                          height: 20,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.03,
                      right: screenWidth * 0.03,
                      bottom: screenHeight * 0.01,
                      top: screenHeight * 0.01,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            3,
                            (index) => Row(
                                  children: [
                                    const ShimmerContainer(
                                      width: 50,
                                      height: 15,
                                      horizontalMargin: 5,
                                    ),
                                    SizedBox(width: screenWidth * 0.01),
                                    if (index <
                                        2) // Add dot if not the last item
                                      Icon(
                                        Icons.fiber_manual_record,
                                        size: screenHeight *
                                            0.01, // Set the desired dot size
                                        color: const Color(0xff24292e),
                                      ),
                                    SizedBox(width: screenWidth * 0.01),
                                  ],
                                )),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ShimmerContainer(
                        width: 15,
                        height: 15,
                        horizontalMargin: 10,
                      ),
                      Row(
                        children: [
                          const ShimmerContainer(
                            width: 35,
                            height: 15,
                            horizontalMargin: 2,
                          ),
                          Icon(
                            Icons.fiber_manual_record,
                            size:
                                screenHeight * 0.01, // Set the desired dot size
                            color: const Color(0xff24292e),
                          ),
                          const ShimmerContainer(
                            width: 85,
                            height: 15,
                            horizontalMargin: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
