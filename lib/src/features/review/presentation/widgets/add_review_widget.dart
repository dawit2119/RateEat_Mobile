import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../homepage/domain/entities/item.dart';

class AddReview extends StatelessWidget {
  final Item? item;
  final bool isItem;
  final RestaurantModel? restaurant;

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  const AddReview(
      {super.key, required this.isItem, this.item, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: getUser()
          ? () {
              if (isItem) {
                context.pushNamed(
                  AppRoutes.addItemReview,
                  pathParameters: {'itemId': item!.itemId},
                  extra: {"item": item},
                );
              } else {
                context.pushNamed(AppRoutes.addRestaurantReview,
                    pathParameters: {'restaurantId': restaurant!.id!},
                    extra: {"restaurant": restaurant});
              }
            }
          : () {
              _showLoginDialog(
                context,
                isItem: isItem,
                item: item,
                restaurant: restaurant,
              );
            },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),
          decoration: const BoxDecoration(
            color: AppColors.primaryButtonColor,
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Iconsax.message,
                color: Colors.white,
                size: 17.sp,
              ),
              SizedBox(
                width: 1.w,
              ),
              SizedBox(
                // width: 35.w,
                child: Text(
                  AppLocalizations.of(context)!.addReviewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showLoginDialog(
  BuildContext context, {
  Item? item,
  required bool isItem,
  RestaurantModel? restaurant,
}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.loginRequiredText,
        ),
        content: Text(AppLocalizations.of(context)!.loginNeededText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: Text(AppLocalizations.of(context)!.cancelText),
          ),
          TextButton(
            onPressed: () {
              var routeInfo = {
                'routeName': isItem
                    ? AppRoutes.addItemReview
                    : AppRoutes.addRestaurantReview,
                'item': item,
                'restaurant': restaurant,
              };
              Navigator.of(ctx).pop(); // Close the dialog
              context.pushNamed(
                AppRoutes.login,
                extra: routeInfo,
              ); // Navigate to login screen
            },
            child: Text(AppLocalizations.of(context)!.loginText),
          ),
        ],
      );
    },
  );
}
