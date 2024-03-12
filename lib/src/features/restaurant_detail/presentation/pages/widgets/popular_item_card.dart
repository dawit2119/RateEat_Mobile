import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';
import '../../../../../../l10n/gen_l10n/app_localizations.dart';

import '../../../../currency_exchange/presentation/widgets/restaurant_item_price_widget.dart';
import '../../../../features.dart';

class PopularItem extends StatelessWidget {
  final RestaurantMenuItem item;
  final Restaurant restaurant;

  const PopularItem({
    super.key,
    required this.item,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = item.imageUrl ??
        "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80";
    final hasRating = (item.averageRating ?? 0) > 0;
    final hasReviews = (item.numberOfReviews ?? 0) > 0;

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": item.id.toString()},
        );
      },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 50.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 16.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheHeight: (13.h).cacheSize(context),
                  progressIndicatorBuilder: (context, url, progress) =>
                      Shimmer.fromColors(
                    baseColor: AppColors.shimmerBaseColor,
                    highlightColor: AppColors.grey100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            // spacing
            SizedBox(height: 1.h),
            // 2) Name + Price row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name ?? "",
                      maxLines: (item.name?.split(" ").length ?? 1) > 1 ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: const Color(0xff24292e),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // UPDATED WIDGET HERE
                  RestaurantItemPriceWidget(
                    originalPrice: item.price?.toDouble() ?? 0.0,
                    originalCurrency: restaurant.currencyCode ?? 'USD',
                    priceStyle: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.7,
                      letterSpacing: 0.1,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: .5.h),
            // 3) Left: rating | Right: number of reviews
            Padding(
              padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 1.2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (hasRating)
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.red,
                          size: 15.sp,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          item.averageRating!.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff24292e),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  if (hasReviews)
                    Text(
                      '${item.numberOfReviews} ${l10n.revText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.28,
                        color: const Color(0xff586069),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
