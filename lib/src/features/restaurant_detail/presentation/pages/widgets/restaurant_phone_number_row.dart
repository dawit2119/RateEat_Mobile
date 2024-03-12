import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/constants.dart';

class RestaurantPhoneNumberRow extends StatefulWidget {
  final List<RestaurantPhoneNumber> phoneNumbers;

  const RestaurantPhoneNumberRow({
    required this.phoneNumbers,
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantPhoneNumberRow> createState() =>
      _RestaurantPhoneNumberRowState();
}

class _RestaurantPhoneNumberRowState extends State<RestaurantPhoneNumberRow> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final numbers = widget.phoneNumbers;

    // Filter out null or empty phone numbers
    final validNumbers = numbers
        .where((number) => number.phoneNumber?.isNotEmpty == true)
        .toList();

    if (validNumbers.isEmpty) return const SizedBox.shrink();

    // Show only first number initially if there are multiple
    final displayNumbers =
        showAll ? validNumbers : validNumbers.take(1).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Iconsax.call,
          size: 17.sp,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Display phone numbers
              for (int i = 0; i < displayNumbers.length; i++) ...[
                GestureDetector(
                  onTap: () {
                    makePhoneCall(displayNumbers[i].phoneNumber ?? '');
                  },
                  child: Text(
                    displayNumbers[i].phoneNumber ?? '',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                // Add comma separator between numbers
                if (i < displayNumbers.length - 1)
                  Text(
                    ', ',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black,
                    ),
                  ),
              ],
              // Show "..more" link if there are hidden numbers
              if (!showAll && validNumbers.length > 1) ...[
                Text(
                  ', ',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAll = true;
                    });
                  },
                  child: Text(
                    '..more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              // Show "..less" link to collapse when expanded
              if (showAll && validNumbers.length > 1) ...[
                Text(
                  ' ',
                  style: TextStyle(fontSize: 15.sp),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAll = false;
                    });
                  },
                  child: Text(
                    '..less',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String formatPhoneNumber(String rawNumber) {
    rawNumber = rawNumber.trim();
    if (rawNumber.startsWith('+212')) {
      return rawNumber;
    }
    if (rawNumber.startsWith('251') && !rawNumber.startsWith('+')) {
      return '+$rawNumber';
    } else if (rawNumber.startsWith('0')) {
      return '+251${rawNumber.substring(1)}';
    } else if (rawNumber.startsWith('+251')) {
      return rawNumber;
    } else {
      return '+251$rawNumber';
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(
      Uri.parse(
        launchUri.toString(),
      ),
    );
  }
}
