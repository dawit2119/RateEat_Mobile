import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/constants/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final Color color;
  final bool isLoading;
  const SubmitButton({
    super.key,
    required this.title,
    this.onClick,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color,
            foregroundColor: Colors.white,
            minimumSize: Size(10.w, 6.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onClick,
        child: isLoading
            ? LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: 24,
                secondRingColor: Colors.white60,
                thirdRingColor: Colors.white38,
              )
            : Text(
                title,
                style: semiBold16.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
