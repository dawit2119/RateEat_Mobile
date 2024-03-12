import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../core/core.dart';
import '../../../../features.dart';

class OpeningClosingTime extends StatelessWidget {
  const OpeningClosingTime({
    super.key,
    required this.restaurant,
  });
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    if (restaurant.closingHour == null || restaurant.openingHour == null) {
      return Text(
        "Unknown opening hour",
        style: medium14.copyWith(
          color: Colors.red,
        ),
      );
    }
    final now = DateTime.now();
    final closingHour = restaurant.closingHour!.split(":");
    final openingHour = restaurant.openingHour!.split(":");
    final closingTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(closingHour[0]),
      int.parse(closingHour[1]),
      int.parse(closingHour[2]),
    );
    final openingTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(openingHour[0]),
      int.parse(openingHour[1]),
      int.parse(openingHour[2]),
    );
    final isOpen = closingTime.isAfter(now) && now.isAfter(openingTime);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOpen ? Icons.access_time_filled : Icons.lock_clock,
          color: isOpen ? Colors.green : Colors.red,
          size: 16.sp,
        ),
        SizedBox(width: 5),
        Text(
          isOpen
              ? AppLocalizations.of(context)!.openNowText
              : AppLocalizations.of(context)!.closedText,
          style: medium14.copyWith(
            color: isOpen ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
