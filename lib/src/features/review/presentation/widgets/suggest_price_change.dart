import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/item_price_change_modal.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_change_modal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SuggestPriceChange extends StatelessWidget {
  final Item? item;
  final bool isItem;
  final RestaurantModel? restaurant;
  final bool showCloseButton;

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  const SuggestPriceChange({
    super.key,
    required this.isItem,
    this.item,
    this.restaurant,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ((isItem && item != null && item!.priceUpdatedAt != null) ||
            (!isItem &&
                restaurant != null &&
                restaurant!.lastPriceUpdate != null))
        ? Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon at the top
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.document_text,
                        color: AppColors.primaryColor,
                        size: 4.5.h,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title text
                    Text(
                      isItem
                          ? AppLocalizations.of(context)!
                              .lastPriceUpdateBeforeText
                          : AppLocalizations.of(context)!
                              .lastMenuUpdateBeforeText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff383749),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Time ago text
                    Text(
                      getTimeAgoString(
                        context,
                        lastUpdate: isItem
                            ? item!.priceUpdatedAt!
                            : restaurant!.lastPriceUpdate!,
                      ),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.grey600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Action button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: getUser()
                            ? () {
                                Navigator.of(context).pop();
                                isItem
                                    ? showItemPriceUpdateModalSheet(
                                        context: context,
                                        navigator: Navigator.of(context),
                                        item: item as ItemModel)
                                    : showPriceUpdateModalSheet(
                                        context: context,
                                        navigator: Navigator.of(context),
                                        restaurant: restaurant);
                              }
                            : () {
                                Navigator.of(context).pop();
                                _showLoginDialog(
                                  context,
                                  isItem: isItem,
                                  item: item,
                                  restaurant: restaurant,
                                );
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isItem ? Iconsax.edit : Iconsax.document_upload,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isItem
                                      ? AppLocalizations.of(context)!
                                          .suggestPriceUpdateText
                                      : AppLocalizations.of(context)!
                                          .uploadMenuText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Close button (X icon) - only show if enabled
              if (showCloseButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: const Color(0xff383749),
                          size: 2.5.h,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          )
        : const SizedBox.shrink();
  }
}

// Function to show the popup dialog nicely
void showMenuInfoDialog(BuildContext context, RestaurantModel restaurant) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: SuggestPriceChange(
            isItem: false,
            restaurant: restaurant,
            showCloseButton: true, // Enable close button
          ),
        ),
      );
    },
  );
}

// Function to show item price info dialog
void showItemPriceInfoDialog(BuildContext context, Item item) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          child: SuggestPriceChange(
            isItem: true,
            item: item,
            showCloseButton: true, // Enable close button
          ),
        ),
      );
    },
  );
}

String getTimeAgoString(BuildContext context, {required DateTime lastUpdate}) {
  final now = DateTime.now();
  final differenceInDays = now.difference(lastUpdate).inDays;

  if (differenceInDays < 30) {
    final daysText = differenceInDays == 1
        ? AppLocalizations.of(context)!.dayText
        : AppLocalizations.of(context)!.daysText;
    return "$differenceInDays $daysText ago";
  } else {
    final months = (differenceInDays / 30).floor();
    final monthText = months == 1 ? "month" : "months";
    return "$months $monthText ago";
  }
}

Color getColorBasedOnDaysDifference(DateTime lastUpdate) {
  final now = DateTime.now();
  final differenceInDays = now.difference(lastUpdate).inDays;
  const int maxDays = 90;
  const Color startColor = Color(0xFFB5FFB8);
  const Color endColor = Color.fromARGB(255, 255, 195, 134);

  if (differenceInDays <= 10) {
    return Color.lerp(startColor, endColor, differenceInDays / 10)!;
  } else if (differenceInDays <= maxDays) {
    return Color.lerp(startColor, endColor, differenceInDays / maxDays)!;
  } else {
    return endColor;
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          AppLocalizations.of(context)!.loginRequiredText,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.loginNeededText,
          style: GoogleFonts.poppins(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.cancelText,
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              var routeInfo = {
                'routeName':
                    isItem ? AppRoutes.itemDetail : AppRoutes.restaurantDetail,
                'item': item,
                'restaurant': restaurant,
              };
              Navigator.of(ctx).pop();
              context.pushNamed(
                AppRoutes.login,
                extra: routeInfo,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff383749),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context)!.loginText,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}
