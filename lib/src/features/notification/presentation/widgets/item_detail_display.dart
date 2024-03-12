import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../homepage/domain/entities/item.dart';

class ItemDetailDisplay extends StatelessWidget {
  final Item item;
  const ItemDetailDisplay({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 5,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      width: double.infinity,
      height: 12.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x146a737d),
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0x146a737d),
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            if (item.ridingTime != "" || item.walkingTime != "")
              Positioned(
                bottom: -3,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (item.ridingTime != "")
                          const Icon(
                            Icons.directions_bus,
                            size: 14,
                          ),
                        const SizedBox(
                          width: 1,
                        ),
                        Text(
                          item.ridingTime,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        if (item.walkingTime != "")
                          const Icon(
                            Icons.directions_walk,
                            size: 14,
                          ),
                        const SizedBox(
                          width: 1,
                        ),
                        Text(
                          item.walkingTime,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl ??
                            "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImages/1699002887700.jpg",
                        memCacheHeight: (10.h).cacheSize(context),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Unable to load\n image",
                              textAlign: TextAlign.center,
                              style: subTitleTextStyle,
                            ),
                          ],
                        ),
                        width: 20.w,
                        height: 10.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        verticalPadding(height: .6),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                width: 48.w,
                                child: Text(
                                  item.itemName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '${item.price!.toInt()} ETB',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Transform.rotate(
                                angle: 0.8,
                                child: const Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60.w,
                              child: Text(
                                item.restaurantName ??
                                    AppLocalizations.of(context)!.nAText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  height: 1.5,
                                  color: AppColors.textLight,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: AppColors.primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "${item.averageRating}/5",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff24292e),
                                    ),
                                  ),
                                  Text(
                                    '(${item.numberOfReviews} Ratings)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
