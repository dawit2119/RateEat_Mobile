import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/core.dart';

class RestaurantSearchResultTile extends StatelessWidget {
  const RestaurantSearchResultTile({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.isRestaurantReview,
  });
  final String restaurantId;
  final String restaurantName;
  final bool isRestaurantReview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isRestaurantReview) {
          context.pushNamed(
            AppRoutes.restaurantReviewFromSharedMedia,
            extra: {'restaurantId': restaurantId},
          );
        } else {
          context.pushNamed(
            AppRoutes.searchFood,
            extra: {'restaurantId': restaurantId},
          );
        }
      },
      child: SizedBox(
        child: Row(
          children: [
            const Icon(
              Iconsax.search_normal_1,
              size: 24,
              color: AppColors.grey400,
            ),
            horizontalPadding(width: 1.2),
            Expanded(
              child: Text(
                restaurantName,
                style: regular16.copyWith(color: AppColors.grey600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            horizontalPadding(width: 1),
            IconButton(
              icon: const Icon(
                Iconsax.export_3,
                size: 20,
                color: AppColors.grey600,
              ),
              onPressed: () {
                context.pushNamed(
                  AppRoutes.restaurantDetail,
                  pathParameters: {'restaurantId': restaurantId},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
