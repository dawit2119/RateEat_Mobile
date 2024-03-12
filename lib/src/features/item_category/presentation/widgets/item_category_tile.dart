import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemCategoryTile extends StatelessWidget {
  final String categoryName;

  const ItemCategoryTile({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      builder: (context, selectionState) {
        final selectedTags = selectionState.selectedCategories;
        return InkWell(
          splashColor:
              (selectedTags.isNotEmpty && selectedTags.contains(categoryName))
                  ? AppColors.secondaryColor.withOpacity(.1)
                  : AppColors.primaryButtonColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10.sp),
          onTap: () {
            context.read<SelectFoodCategoryBloc>().add(
                  (selectedTags.isNotEmpty &&
                          selectedTags.contains(categoryName))
                      ? UnselectFoodCategory(foodCategory: categoryName)
                      : SelectFoodCategory(foodCategory: categoryName),
                );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (selectedTags.isNotEmpty &&
                        selectedTags.contains(categoryName))
                    ? AppColors.primaryButtonColor
                    : AppColors.grey200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 20.sp),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: (selectedTags.isNotEmpty &&
                          selectedTags.contains(categoryName))
                      ? AppColors.primaryButtonColor
                      : AppColors.secondaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
