import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditOrderPageCategoryWidget extends StatefulWidget {
  final QRCategory category;
  final List<QRItem> items;
  final bool isSelected;
  final Function selector;
  const EditOrderPageCategoryWidget(
      {super.key,
      required this.category,
      required this.items,
      required this.isSelected,
      required this.selector});

  @override
  State<StatefulWidget> createState() {
    return _EditOrderPageCategoryWidgetState();
  }
}

class _EditOrderPageCategoryWidgetState
    extends State<EditOrderPageCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                child: const Text(
                  "See All",
                  style: TextStyle(color: AppColors.textDark),
                ),
                onTap: () {
                  widget.selector(widget.category);
                },
              )
          ]),
        ),
        SizedBox(
          height: widget.isSelected
              ? 65.h - MediaQuery.of(context).viewInsets.bottom
              : null,
          child: !widget.isSelected
              ? SizedBox(
                  width: 95.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...List.generate(
                          widget.items.length,
                          (index) => Container(
                            width: 40.w,
                            height: 30.h,
                            margin: EdgeInsets.all(2.w),
                            child: EditQROrderItemCard(
                              item: widget.items[index],
                              currencyCode: 'ETB',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.count(
                  scrollDirection: Axis.vertical,
                  primary: false,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                  crossAxisCount: 2,
                  children: List.generate(
                    widget.items.length,
                    (index) => EditQROrderItemCard(
                      item: widget.items[index],
                      currencyCode: 'ETB',
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
