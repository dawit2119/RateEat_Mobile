import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core.dart';

class CustomTextInputField extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final Color fillColor;
  final Color labelColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final GestureTapCallback? onTap;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool canRequestFocus;
  final VoidCallback? onCancelled;
  final Color backgroundColor;
  final bool showTrailing;

  const CustomTextInputField({
    super.key,
    this.onTap,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.inputType,
    this.onCancelled,
    required this.hintText,
    required this.controller,
    this.autoFocus = false,
    this.showTrailing = false,
    this.canRequestFocus = true,
    this.fillColor = Colors.white,
    this.labelColor = AppColors.grey400,
    this.iconData = Iconsax.search_normal_1,
    this.backgroundColor = AppColors.fieldBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        color: backgroundColor,
      ),
      height: 8.h,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              onTap?.call();
            },
            child: TextFormField(
              onTap: onTap,
              onChanged: onChanged,
              focusNode: focusNode,
              autofocus: autoFocus,
              canRequestFocus: canRequestFocus,
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.grey500,
                  fontSize: 16.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.h,
                ),
                hintText: hintText,
                fillColor: fillColor,
                labelStyle: TextStyle(
                  color: labelColor,
                  fontSize: 15.sp,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.h,
                  ), // Adjust the vertical padding
                  child: Icon(
                    iconData,
                    color: AppColors.grey500,
                    size: 2.5.h,
                  ),
                ),
                suffixIcon: showTrailing
                    ? GestureDetector(
                        onTap: onCancelled,
                        child: Icon(
                          Icons.close,
                          color: AppColors.grey500,
                          size: 2.2.h,
                        ))
                    : null,
              ),
              validator: validator ?? (value) => null,
            ),
          ),
        ),
      ),
    );
  }
}
