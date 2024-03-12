import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/core.dart';

class FoodSearchResultTile extends StatelessWidget {
  const FoodSearchResultTile({
    super.key,
    required this.foodId,
    required this.foodName,
  });
  final String foodId;
  final String foodName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.foodReviewFromSharedMedia,
          extra: {'foodId': foodId},
        );
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
                foodName,
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
                  AppRoutes.itemDetail,
                  pathParameters: {'foodId': foodId},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
