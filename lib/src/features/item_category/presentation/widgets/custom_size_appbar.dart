import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class CustomSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomSizeAppBar({
    super.key,
    required this.title,
    required this.stepperIndex,
    this.onBackPress,
    this.onSkipPress,
    required this.totalSteps,
  });

  final GestureTapCallback? onBackPress;
  final GestureTapCallback? onSkipPress;
  final String title;
  final int stepperIndex;
  final int totalSteps;

  @override
  Size get preferredSize =>
      Size.fromHeight(36.sp); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 10.sp, 16.sp, 0),
      child: StepIndicator(
        totalSteps: totalSteps,
        currentStep: stepperIndex,
        pageTitle: title,
        onBackPress: onBackPress,
        onSkipPress: onSkipPress,
      ),
    );
  }
}
