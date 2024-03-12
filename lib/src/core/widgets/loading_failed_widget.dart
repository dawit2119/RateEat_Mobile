import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core.dart';

// Don't pul inside unbounded height widget
class FailureStateWidget extends StatelessWidget {
  const FailureStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.buttonOnPress,
  });
  final String title;
  final String message;
  final String imagePath;
  final GestureTapCallback buttonOnPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              if (imagePath.isNotEmpty)
                Expanded(
                  child: SvgPicture.asset(
                    imagePath,
                  ),
                ),
              verticalPadding(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalPadding(height: 1),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              CustomMainButton(
                title: "Try Again",
                onTap: buttonOnPress,
                horizontalPadding: 16.sp,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
