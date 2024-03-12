import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/shimmer_container.dart';

class ItemSearchResultCardShimmer extends StatelessWidget {
  const ItemSearchResultCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: screenWidth * 0.2, // Matching 50.w
        height: screenHeight * 0.34, // Matching 34.h
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: SizedBox(
                  width: screenWidth * 0.45,
                  height: screenHeight * 0.2,
                  child: const ShimmerContainer(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                bottom: -3,
                right: 0,
                child: Container(
                  height: screenHeight * 0.03, // Matching 3.h
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.21, // Below the image placeholder
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: screenWidth * 0.45,
                      height: 15,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerContainer(
                          width: screenWidth * 0.2,
                          height: 15,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const ShimmerContainer(
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 5),
                            ShimmerContainer(
                              width: screenWidth * 0.1,
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
