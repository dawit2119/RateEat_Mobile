import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool loadingState;
  final Function()? onClick;
  final double? customWidth;
  final double? customHeight;
  final double? fontSize;
  final BorderRadiusGeometry? customBorderRadius;

  const LoadingButton({
    super.key,
    required this.title,
    required this.color,
    required this.onClick,
    this.loadingState = false,
    this.customWidth,
    this.customHeight,
    this.customBorderRadius,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: customHeight ?? 50,
      child: ElevatedButton(
        onPressed: onClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            color,
          ),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: customBorderRadius ??
                  const BorderRadius.all(
                    Radius.circular(10),
                  ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingState == true
                ? SizedBox(
                    width: 28.5,
                    height: 28.5,
                    child: LoadingAnimationWidget.dotsTriangle(
                        color: Colors.white, size: screenHeight * 0.035),
                  )
                : const SizedBox(),
            loadingState == true
                ? const SizedBox(width: 14.75)
                : const SizedBox(),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
