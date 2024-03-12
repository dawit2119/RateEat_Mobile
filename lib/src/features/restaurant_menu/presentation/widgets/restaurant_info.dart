import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../features.dart';

class RestaurantInfo extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              restaurant.name!,
              maxLines: 3,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // const Spacer(),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
