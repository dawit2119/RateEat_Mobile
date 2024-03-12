import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantMenuErrorWidget extends StatelessWidget {
  final String message;
  final String restaurantId;
  final void Function() refreshButtonOnPressed;
  const RestaurantMenuErrorWidget({
    super.key,
    required this.message,
    required this.restaurantId,
    required this.refreshButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: refreshButtonOnPressed,
            child: Text(
              AppLocalizations.of(context)!.refreshText,
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
