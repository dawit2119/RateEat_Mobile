import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core.dart';

class CustomMainButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double horizontalPadding;
  const CustomMainButton({
    super.key,
    required this.title,
    required this.onTap,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: 7.h,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
            backgroundColor: const WidgetStatePropertyAll<Color>(
              AppColors.primaryColor,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: mainButtonStyle,
            ),
          ),
        ),
      ),
    );
  }
}
