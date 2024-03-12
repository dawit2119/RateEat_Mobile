import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextInputField extends StatelessWidget {
  final String hintText;
  final String iconPath;
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
    required this.hintText,
    required this.iconPath,
    required this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.canRequestFocus = false,
    this.onTap,
    this.onChanged,
    this.fillColor = Colors.white,
    this.labelColor = AppColors.grey400,
    this.validator,
    this.inputType,
    this.onCancelled,
    this.backgroundColor = AppColors.fieldBackgroundColor,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        color: backgroundColor,
      ),
      height: SizeConfig.screenHeight * 0.059,
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
              contentPadding: EdgeInsets.zero,
              hintText: hintText,
              fillColor: fillColor,
              labelStyle: TextStyle(
                color: labelColor,
                fontSize: 18.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                  vertical: 15.sp,
                ), // Adjust the vertical padding
                child: SvgPicture.asset(
                  iconPath,
                ),
              ),
              suffixIcon: showTrailing
                  ? Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: GestureDetector(
                        onTap: onCancelled,
                        child: Container(
                          height: 5.sp,
                          width: 5.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: SvgPicture.asset(
                              "assets/icons/x.svg",
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            validator: validator ?? (value) => null,
          ),
        ),
      ),
    );
  }
}
