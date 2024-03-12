import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:iconsax/iconsax.dart';

class NearByRestaurantCard extends StatelessWidget {
  const NearByRestaurantCard({super.key, required this.restaurant});
  final NearByRestaurantResponse restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SimpleReviewStepperBloc>().add(
              SimpleReviewStepperUpdate(
                restaurant: restaurant,
                item: null,
              ),
            );
        //* Navigate to Items Selection pag
        context.pushNamed(
          AppRoutes.quickAddItemSelect,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
        ),
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
                restaurant.name!,
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
                  pathParameters: {'restaurantId': restaurant.id!},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
