import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/rating_and_reviews.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderItemTitle extends StatelessWidget {
  final Item item;
  final String currencyCode;
  const OrderItemTitle({
    super.key,
    required this.item,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 1.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 45.w,
                child: Text(
                  item.itemName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: const Color(0xff24292e),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${item.price} $currencyCode",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.36,
                      color: Colors.black,
                    ),
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
      ],
    );
  }
}
