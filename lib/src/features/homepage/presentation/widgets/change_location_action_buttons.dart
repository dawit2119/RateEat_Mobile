import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/widgets/square_icon_button.dart';

class ChangeLocationActionButtons extends StatelessWidget {
  const ChangeLocationActionButtons({
    super.key,
    required this.onChangeUserLocation,
    required this.onNavigateToUserLocation,
    required this.onNavigateToPinLocation,
  });
  final GestureTapCallback onChangeUserLocation;
  final GestureTapCallback onNavigateToUserLocation;
  final GestureTapCallback onNavigateToPinLocation;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: 100.w,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SquareIconButton(
                onTap: onNavigateToUserLocation,
                iconData: Iconsax.gps,
              ),
              verticalPadding(height: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onChangeUserLocation,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 30.sp),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.continueText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  horizontalPadding(width: 1),
                  SquareIconButton(
                    onTap: onNavigateToPinLocation,
                    iconData: Iconsax.location,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
