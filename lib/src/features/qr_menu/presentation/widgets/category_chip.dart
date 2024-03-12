import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryChip extends StatefulWidget {
  final Widget? leadingWidget;
  final String categoryName;
  final bool isSelected;
  final Color selectionColor;
  const CategoryChip(
      {super.key,
      required this.selectionColor,
      required this.categoryName,
      this.leadingWidget,
      this.isSelected = false});

  @override
  State<CategoryChip> createState() => _CategoryCategoryChipState();
}

class _CategoryCategoryChipState extends State<CategoryChip> {
  Color textColor = Colors.black;
  Size maximumSize = const Size(64, 36);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0.w),
      child: GestureDetector(
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.w),
            decoration: BoxDecoration(
                color: widget.isSelected
                    ? widget.selectionColor.withOpacity(0.2)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(
                    color: widget.isSelected
                        ? widget.selectionColor
                        : AppColors.grey400)),
            child: Center(
                child: Row(
              children: [
                widget.leadingWidget ?? const SizedBox(),
                widget.leadingWidget != null
                    ? SizedBox(
                        width: 2.w,
                      )
                    : const SizedBox(),
                Text(
                  widget.categoryName,
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
