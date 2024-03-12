import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../data/models/discover_restaurant_result_model/discover_restaurant_item_model.dart';
import './all_menus_tile.dart';

class RestaurantItemsScrollableList extends StatelessWidget {
  const RestaurantItemsScrollableList({
    super.key,
    required this.restaurantItems,
    required this.restaurantId,
    required this.currencyCode,
  });

  final List<DiscoverRestaurantItem> restaurantItems;
  final String restaurantId;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: (restaurantItems.isNotEmpty)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  restaurantItems.length,
                  (itemIndex) => ItemCard(
                    item: restaurantItems[itemIndex],
                    currencyCode: currencyCode,
                  ),
                ),
                GotoAllMenusCard(
                  restaurantId: restaurantId,
                ),
              ],
            )
          : Center(
              child: Text(
                "There's no items",
                style: GoogleFonts.poppins(),
              ),
            ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.currencyCode,
  });

  final DiscoverRestaurantItem item;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": item.id!},
        );
      },
      child: Container(
        width: 132,
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* image for the items
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                height: 29.w,
                width: 29.w,
                item.itemImages![0].url!,
                cacheHeight: (29.w).cacheSize(context),
                cacheWidth: (29.w).cacheSize(context),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.shimmerBaseColor,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: const SizedBox.expand(),
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors
                          .grey, // You can customize the color for the error state
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            verticalPadding(height: .5),
            Text(
              item.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            verticalPadding(height: .2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/star_full_rounded.svg",
                  colorFilter:
                      ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  height: 16,
                  width: 16,
                ),
                horizontalPadding(width: .4),
                Text(
                  item.averageRating!.toStringAsFixed(1),
                  style: subTitleTextStyle,
                ),
                Text(
                  "(${item.numberOfReviews})",
                  style: subTitleTextStyle.copyWith(
                    color: AppColors.grey300,
                  ),
                ),
              ],
            ),
            verticalPadding(height: .2),
            Text(
              "${item.price!} $currencyCode",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
