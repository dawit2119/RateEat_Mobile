import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'restaurant_map.dart';

class RestaurantDirectionDialog extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantDirectionDialog({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 16, // Strong shadow for elevation
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Only as tall as its content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  restaurant.name ?? "",
                  maxLines: 2,
                  style: semiBold18.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff24292e),
                    height: 1.2,
                  ),
                )),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            RestaurantMapDisplay(restaurant: restaurant),
          ],
        ),
      ),
    );
  }
}
