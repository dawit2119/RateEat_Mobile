import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryWidget extends StatefulWidget {
  final QRCategory category;
  final List<QRItem> items;
  final bool isSelected;
  final Function selector;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.items,
    required this.isSelected,
    required this.selector,
  });

  @override
  State<StatefulWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with category name and "See All" button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name,
                style: GoogleFonts.poppins(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              if (!widget.isSelected)
                GestureDetector(
                  onTap: () => widget.selector(widget.category),
                  child: const Text(
                    "See All",
                    style: TextStyle(color: AppColors.textDark),
                  ),
                ),
            ],
          ),
        ),

        // Horizontal scroll view when NOT selected - FIXED
        if (!widget.isSelected)
          SizedBox(
            height: 28.h, // Increased from 22.h to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: QRItemCard(item: widget.items[index]),
                );
              },
            ),
          ),

        // Grid view when selected
        if (widget.isSelected)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.75,
              ),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return QRItemCard(item: widget.items[index]);
              },
            ),
          ),

        // Bottom spacing
        SizedBox(height: 2.h),
      ],
    );
  }
}
