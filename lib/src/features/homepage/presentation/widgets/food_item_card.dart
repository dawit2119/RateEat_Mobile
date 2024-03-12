import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/item.dart';

class FoodCard extends StatelessWidget {
  final Item item;
  const FoodCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl?.trim().isNotEmpty == true
        ? item.imageUrl!.trim()
        : "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80";

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.relatedItems,
          pathParameters: {
            "itemId": item.itemId,
          },
        );
      },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 21.h,
        width: 50.w,
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
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 12.h,
              child: Container(
                width: 50.w,
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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      debugPrint("IMAGE FAILED URL: $url");
                      debugPrint("IMAGE ERROR: $error");

                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: item name (2 lines max)
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.itemName, // e.g. "Chicken Burger"
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: semiBold14.copyWith(
                        color: const Color(0xff24292e),
                      ),
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // RIGHT: two rows (price, then star+rating)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // First line: price
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${item.price} ${item.currencyCode}',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: semiBold14.copyWith(
                              fontSize: 1.2.h,
                              height: 1.2,
                              letterSpacing: 0.1,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.3.h),

                        // Second line: star + rating
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.primaryColor,
                              size: 1.5.h,
                            ),
                            SizedBox(width: 0.5.w),
                            Text(
                              item.averageRating?.toString() ?? "",
                              style: medium14.copyWith(
                                fontSize: 1.2.h,
                                color: const Color(0xff24292e),
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
            const SizedBox(height: 3),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  // Clickable Restaurant Name with Link Icon
                  Expanded(
                    flex: 6,
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
                            size: 1.2.h,
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
                                fontSize: 1.4.h,
                                color: const Color(0xff24292e),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Rating

                  // Distance (optional, shown only if not "0.0")
                  if (item.distance != "0.0") ...[
                    SizedBox(width: 1.5.w),
                    Icon(
                      Icons.location_on_rounded,
                      size: 1.5.h,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 0.3.w),
                    Text(
                      "${double.parse(item.distance).toStringAsFixed(1)} ${AppLocalizations.of(context)!.kiloMeterText}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: medium14.copyWith(
                        fontSize: 1.2.h,
                        color: const Color(0xff24292e),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
