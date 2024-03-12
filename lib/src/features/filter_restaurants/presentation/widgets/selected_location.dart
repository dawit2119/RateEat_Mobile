import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectedLocation extends StatelessWidget {
  final String location;
  final String street;

  const SelectedLocation(
      {super.key, required this.location, required this.street});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Wrap the DottedBorder with ClipRRect
      borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      child: DottedBorder(
        options: RectDottedBorderOptions(
          strokeWidth: 1.5.w,
          dashPattern: const [17, 20],
          color: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_searching,
              size: 38,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Text(location,
                      style: locationTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  width: 50.w,
                  child: Text(street,
                      style: streetTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
