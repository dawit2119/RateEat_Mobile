import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/rating_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class QROrderItemCard extends StatefulWidget {
  final QRItem item;
  final Restaurant? restaurant;
  final String currencyCode;

  const QROrderItemCard({
    super.key,
    required this.item,
    this.restaurant,
    required this.currencyCode,
  });

  @override
  State<QROrderItemCard> createState() {
    return QROrderItemCardState();
  }
}

class QROrderItemCardState extends State<QROrderItemCard> {
  late final QRItem item = widget.item;
  late final Restaurant? restaurant = widget.restaurant;
  late final String currencyCode = widget.currencyCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   context.pushNamed(
      //     AppRoutes.orderItemDetail,
      //     extra: {
      //       'item': item,
      //       "restaurant": restaurant,
      //       "currencyCode": currencyCode,
      //     },
      //   );
      // },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 50.w,
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 1.5.h - 13.sp,
        ), // horizontal padding will decrease when font size incleases to prevent overflow
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
        child: Builder(
          builder: (context) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 12.h,
                  child: Container(
                    width: 48.w,
                    height: 11.h,
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
                        imageUrl: item.imageUrl ??
                            "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
                        memCacheHeight: (11.h).cacheSize(context),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
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
                Container(
                  margin: EdgeInsets.only(
                    top: .5.h,
                  ),
                  child: Text(
                    item.name,
                    maxLines: item.name.split(" ").length > 1 ? 1 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.7,
                      color: const Color(0xff24292e),
                    ),
                  ),
                ),
                Row(
                  children: [
                    item.rating > 0
                        ? OrderItemRatingBar(
                            rating: item.rating,
                          )
                        : Container(
                            margin: EdgeInsets.only(
                              left: 2.w,
                              top: .5.h,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.notRatedText,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 1.5.h,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: -0.28,
                                color: const Color(0xff586069),
                              ),
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: item.rating > 0
                          ? Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.red,
                                  size: 1.5.h,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  item.rating.toStringAsFixed(1),
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontSize: 1.2.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff24292e),
                                  ),
                                ),
                                SizedBox(
                                  width: 0.5.w,
                                ),
                                Text(
                                  '/5',
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontSize: 1.2.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff6a737d),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.red,
                                  size: 1.5.h,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.noRateText,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontSize: 1.2.h,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff24292e),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 2.w,
                    top: .5.h,
                  ),
                  width: 35.w,
                  child: Text(
                    item.numberOfReviews > 0
                        ? '${item.numberOfReviews} ${AppLocalizations.of(context)!.revText}'
                        : AppLocalizations.of(context)!.noRevText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontSize: 1.5.h,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.28,
                      color: const Color(0xff586069),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 2.w,
                    top: .5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.price} $currencyCode',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.7,
                          color: const Color(0xffff3008),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: .7.h, horizontal: 2.w),
                            decoration: const BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  15,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<QROrderBloc>()
                                        .add(RemoveItemFromCart(item));
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: context
                                            .read<QROrderBloc>()
                                            .isItemInOrder(item)
                                        ? const Color(0xffFF3008)
                                        : Colors.white,
                                    child: SvgPicture.asset(
                                      "assets/icons/minus.svg",
                                      fit: BoxFit.scaleDown,
                                      height: 26.sp,
                                      width: 26.sp,
                                      colorFilter: ColorFilter.mode(
                                        !context
                                                .read<QROrderBloc>()
                                                .isItemInOrder(item)
                                            ? const Color(0xffFF3008)
                                            : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                Text(
                                  context
                                      .read<QROrderBloc>()
                                      .getItemCount(item)
                                      .toString(),
                                  style: GoogleFonts.sen(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<QROrderBloc>()
                                        .add(AddItemToCart(item));
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xffFF3008),
                                    child: SvgPicture.asset(
                                      "assets/icons/plus_2.svg",
                                      height: 26.sp,
                                      width: 26.sp,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
