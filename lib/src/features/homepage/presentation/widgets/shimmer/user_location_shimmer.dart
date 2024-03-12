import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/core/widgets/shimmer_container.dart';
import 'package:shimmer/shimmer.dart';

class UserLocationShimmer extends StatelessWidget {
  const UserLocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: ShimmerContainer(
                            width: 60,
                            height: 60,
                            borderRadius: 30,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          ShimmerContainer(
                            width: 120,
                            height: 20,
                          ),
                          Row(
                            children: [
                              ShimmerContainer(
                                width: 60,
                                height: 20,
                                horizontalMargin: 5,
                              ),
                              ShimmerContainer(
                                width: 80,
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  ShimmerContainer(
                    width: 80,
                    height: 40,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                elevation: 3,
                child: ShimmerContainer(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
