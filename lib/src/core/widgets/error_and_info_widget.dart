import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ErrorAndInfoDisplayWidget extends StatelessWidget {
  const ErrorAndInfoDisplayWidget({
    super.key,
    required this.assetImage,
    required this.title,
    required this.description,
    this.onPressed,
    this.buttonText,
  });

  final String assetImage;
  final String title;
  final String description;
  final GestureTapCallback? onPressed;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40.h,
        minWidth: 100.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 16.h,
                minHeight: 8.h,
                maxWidth: 40.w,
              ),
              child: SvgPicture.asset(
                assetImage,
                fit: BoxFit.fitHeight,
              ),
            ),
            verticalPadding(height: 2),
            Text(
              title,
              style: titleTextStyle.copyWith(
                fontSize: 5.w,
              ),
              textAlign: TextAlign.center,
            ),
            verticalPadding(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                description,
                style: subTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            verticalPadding(height: 2),
            if (onPressed != null)
              CustomTextButton(
                padding: 20,
                title: buttonText ?? AppLocalizations.of(context)!.retryText,
                ontap: onPressed!,
              ),
          ],
        ),
      ),
    );
  }
}
