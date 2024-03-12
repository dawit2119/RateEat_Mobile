import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FollowingUserCardShimmer extends StatelessWidget {
  const FollowingUserCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.h),
                  child: ShimmerContainer(width: 5.h, height: 5.h),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerContainer(width: 35.w, height: 2.h),
                    ShimmerContainer(width: 25.w, height: 2.h),
                  ],
                ),
                Expanded(child: Container()),
                ShimmerContainer(width: 20.w, height: 5.h),
              ],
            ),
          ],
        ));
  }
}
