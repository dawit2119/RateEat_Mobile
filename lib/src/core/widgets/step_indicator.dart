import 'package:flutter/material.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../core.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final String? pageTitle;
  final GestureTapCallback? onBackPress;
  final GestureTapCallback? onSkipPress;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.pageTitle,
    this.onBackPress,
    this.onSkipPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: onBackPress,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grey600,
              ),
              child: Text(AppLocalizations.of(context)!.backText),
            ),
            onSkipPress == null
                ? Container()
                : TextButton(
                    onPressed: onSkipPress,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.grey600,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.skipText,
                    ),
                  ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (pageTitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Center(
                  child: Text(
                    pageTitle!,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            verticalPadding(height: .5),
            StepProgressIndicator(
              customSize: (p0, p1) => 2,
              padding: 4,
              totalSteps: totalSteps,
              currentStep: currentStep,
              selectedColor: AppColors.secondaryColor,
              unselectedColor: AppColors.grey200,
            ),
          ],
        ),
      ]),
    );
  }
}
