import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItemCard extends StatelessWidget {
  final ItemModel item;
  final String currencyCode;
  const CategoryItemCard({
    super.key,
    required this.item,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": item.itemId},
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 1.h,
        ),
        child: Container(
          // color: Colors.blue,
          padding: EdgeInsets.only(right: 3.w, top: 1.h, bottom: 1.h),
          height: 12.h,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  height: 10.h,
                  width: 10.h,
                  item.imageUrl,
                  cacheHeight: (10.h).cacheSize(context),
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Container(
                        height: 10.h,
                        width: 10.h,
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
                      height: 10.h,
                      width: 10.h,
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
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 2.1.h,
                      ),
                    ),
                    // item.ingredients!.isNotEmpty
                    //     ? SizedBox(
                    //         width: 100.w - 24,
                    //         height: 2.h,
                    //         child: ListView.builder(
                    //           shrinkWrap: true,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: item.ingredients!.length,
                    //           itemBuilder: (context, index) => Container(
                    //             margin: const EdgeInsets.only(right: 4),
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 8, vertical: 2),
                    //             decoration: BoxDecoration(
                    //               color: Colors.green.withOpacity(.1),
                    //               borderRadius: BorderRadius.circular(8),
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 item.ingredients![index].name,
                    //                 style: GoogleFonts.getFont(
                    //                   'Poppins',
                    //                   fontSize: 1.2.h,
                    //                   fontWeight: FontWeight.w400,
                    //                   color: Colors.green,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Container(
                    //         margin: const EdgeInsets.only(right: 4),
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 8, vertical: 4),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.primaryColor.withOpacity(.1),
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Text(
                    //           AppLocalizations.of(context)!.tagNotAvailableText,
                    //           style: GoogleFonts.getFont(
                    //             'Poppins',
                    //             fontSize: 1.4.h,
                    //             fontWeight: FontWeight.w500,
                    //             color: AppColors.primaryColor,
                    //           ),
                    //         ),
                    //       ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.red,
                              size: 1.6.h,
                            ),
                            SizedBox(width: .4.w),
                            Text(
                              "${item.averageRating}/5",
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 1.5.h,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff24292e),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '(${item.numberOfReviews} ${AppLocalizations.of(context)!.reviewsText})',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 1.5.h,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff6a737d),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${item.price} $currencyCode",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 2.h,
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
      ),
    );
  }
}
