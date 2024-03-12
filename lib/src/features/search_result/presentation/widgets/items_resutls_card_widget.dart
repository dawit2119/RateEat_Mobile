import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/core.dart';
import '../../../currency_exchange/currency_exchange.dart';
import '../../../features.dart';

class ItemSearchResultCard extends StatelessWidget {
  final ItemModel item;

  const ItemSearchResultCard({
    super.key,
    required this.item,
  });

  bool get hasImage => (item.imageUrl != null && item.imageUrl!.isNotEmpty);

  bool get isFeasibleWalkingTime {
    try {
      final parts = item.walkingTime.split(" ");
      if (parts.length < 2) return false;
      final time = double.parse(parts[0]);
      final measurement = parts[1];
      return time <= 40 && measurement == "min";
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.relatedItems,
          pathParameters: {"itemId": item.itemId},
        );
      },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 36.h,
        //width: 100.w,
        padding: EdgeInsets.only(
          top: 1.w,
          right: 1.w,
          left: 1.w,
          bottom: 1.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IMAGE
            SizedBox(
              height: 22.h,
              child: Container(
                width: 100.w,
                height: 10.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x146a737d),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl!,
                          memCacheHeight: (9.5.h).cacheSize(context),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.network(
                              "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740",
                              fit: BoxFit.cover,
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) =>
                              Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.grey100,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Image.network(
                          "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // NAME + PRICE ROW (same as FoodCard)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              width: double.infinity,
              child: Text(
                item.itemName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: semiBold16.copyWith(
                  color: const Color(0xff24292e),
                ),
              ),
            ),

            const SizedBox(height: 3),

            // 2. LEFT: RESTAURANT + RIGHT: PRICE
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  // LEFT: Clickable Restaurant Name
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        var id = item.categories?.menu?.restaurant?.id;
                        if (id != null) {
                          context.pushNamed(
                            AppRoutes.restaurantDetail,
                            pathParameters: {'restaurantId': id},
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.open_in_new,
                            size: 1.8.h,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              item.categories?.menu?.restaurant?.name ??
                                  item.restaurantName ??
                                  "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: medium14.copyWith(
                                //fontSize: 1.4.h,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // RIGHT: SmartCurrencyPriceWidget
                  SmartCurrencyPriceWidget(
                    originalPrice: item.price?.toDouble() ?? 0.0,
                    originalCurrency: item.currencyCode ?? 'USD',
                    priceStyle: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: 0.1,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // YOUR SPECIFIED RATING + DISTANCE ROW (bottom)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Rating (Left side)
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.primaryColor,
                        size: 1.6.h,
                      ),
                      SizedBox(width: 0.6.h),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  (item.averageRating ?? 0).toStringAsFixed(1),
                              style: medium14.copyWith(
                                fontSize: 1.2.h,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(text: " • "),
                            TextSpan(
                              text:
                                  "(${item.numberOfReviews ?? 0} ${AppLocalizations.of(context)!.revText})",
                              style: medium14.copyWith(
                                fontSize: 1.2.h,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Distance (Right side)
                  if (item.distance != null && item.distance!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _distanceText(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: medium14.copyWith(
                              fontSize: 1.3.h,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 0.5.w),
                          isFeasibleWalkingTime
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk,
                                      size: 1.4.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      item.walkingTime,
                                      style: medium14.copyWith(
                                        fontSize: 1.3.h,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.directions_bus,
                                      size: 1.4.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      item.ridingTime,
                                      style: medium14.copyWith(
                                        fontSize: 1.3.h,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _distanceText(BuildContext context) {
    final d = double.tryParse(item.distance ?? "0") ?? 0;
    final isMeter = d < 1;
    final value =
        isMeter ? (d * 1000).toStringAsFixed(0) : d.toStringAsFixed(1);
    final unit = isMeter
        ? AppLocalizations.of(context)!.meterText
        : AppLocalizations.of(context)!.kiloMeterText;
    return "$value $unit";
  }
}
