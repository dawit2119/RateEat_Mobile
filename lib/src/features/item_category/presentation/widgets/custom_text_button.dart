import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final double padding;
  const CustomTextButton(
      {super.key, required this.title, required this.ontap, this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: padding)),
          overlayColor: const WidgetStatePropertyAll(AppColors.errrorColor),
          backgroundColor:
              WidgetStatePropertyAll(AppColors.errrorColor.withOpacity(.9)),
        ),
        onPressed: ontap,
        child: Text(
          title,
          style: textButtonStyle.copyWith(
            color: Colors.white,
          ),
        ));
  }
}
