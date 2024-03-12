import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/rating_and_reviews.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../currency_exchange/currency_exchange.dart';
import '../../../../review/presentation/widgets/suggest_price_change.dart';

class ItemTitle extends StatelessWidget {
  final Item item;
  final String restaurantName;
  final String currencyCode;
  const ItemTitle({
    super.key,
    required this.item,
    required this.restaurantName,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 2.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 45.w,
                child: Text(item.itemName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: semiBold18.copyWith(
                      color: const Color(0xff24292e),
                      height: 1.2,
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SmartCurrencyPriceWidget(
                    originalPrice: item.price?.toDouble() ?? 0.0,
                    originalCurrency: item.currencyCode ?? 'USD',
                    priceStyle: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.7,
                      letterSpacing: 0.1,
                      color: AppColors.primaryColor,
                    ),
                    // currencyStyle: GoogleFonts.poppins(
                    //   fontSize: 10.sp,
                    //   fontWeight: FontWeight.w400,
                    //   color: const Color(0xff6a737d),
                    // ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<PopularItemReviewsBloc, PopularItemReviewsState>(
                    builder: (context, state) {
                      if (state is PopularItemReviewsLoaded) {
                        final reviews = state.popularReviews.reviews;
                        if (reviews.isNotEmpty) {
                          return RatingReviewWidget(
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.itemReviews,
                                pathParameters: {'itemId': item.itemId},
                                extra: {
                                  'item': item,
                                },
                              );
                            },
                            rating: state.popularReviews.averageRating,
                            noOfReviews: state.popularReviews.numberOfReviews,
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.dividerColor,
        ),
        SizedBox(height: 0.5.h),
        Container(
          margin: EdgeInsets.only(bottom: 6.sp),
          height: 3.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Icon and Restaurant Name
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.shop5,
                      color: AppColors.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (item.categories?.menu?.restaurant != null) {
                            context.pushNamed(
                              AppRoutes.restaurantDetail,
                              pathParameters: {
                                'restaurantId':
                                    item.categories!.menu!.restaurant!.id!
                              },
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          item.restaurantName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: Info Icon
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  size: 22.sp,
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  showItemPriceInfoDialog(context, item);
                },
                tooltip: 'Price suggestion',
              ),
            ],
          ),
        ),
        SizedBox(height: 0.5.h),
        const Divider(
          color: AppColors.dividerColor,
        ),
      ],
    );
  }
}
