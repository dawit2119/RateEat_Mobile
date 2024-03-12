import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OfflineDataWidget extends StatelessWidget {
  const OfflineDataWidget({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 10.h,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5.h),
        color: const Color(0xffFFFDE7),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -1.5.h,
            top: -1.5.h,
            child: IconButton(
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: onPressed,
              icon: Icon(
                Icons.close,
                size: 2.2.h,
                color: AppColors.grey500,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.cloud_cross,
                color: Color(0xffFFA000),
              ),
              horizontalPadding(width: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You're Viewing Offline Data",
                      style: semiBold16.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.grey700,
                      ),
                    ),
                    verticalPadding(height: .4),
                    Expanded(
                      child: Text(
                        "You’re currently offline. Connect to the internet to get updated data.",
                        style: regular16.copyWith(
                          fontSize: 15.sp, //
                          color: AppColors.grey600,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
