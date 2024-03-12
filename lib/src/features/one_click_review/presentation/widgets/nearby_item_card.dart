import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class NearByItemCard extends StatelessWidget {
  const NearByItemCard({
    super.key,
    required this.item,
  });
  final NearByItemResponse item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleReviewStepperBloc, SimpleReviewStepperState>(
        builder: (context, state) {
      final isSelected = ((state.simpleAddReviewStepperProps.item != null) &&
          (state.simpleAddReviewStepperProps.item!.id == item.id));
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: GestureDetector(
          onTap: () {
            //* Add to Steps
            context
                .read<SimpleReviewStepperBloc>()
                .add(SimpleReviewStepperUpdate(item: item));
          },
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
                  item.name ?? "",
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
                    pathParameters: {'itemId': item.id!},
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
