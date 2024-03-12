import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class SelectedOrderItemPreview extends StatelessWidget {
  final Item item;
  final Restaurant restaurant;
  final String currencyCode;
  const SelectedOrderItemPreview({
    super.key,
    required this.item,
    required this.restaurant,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.orderItemDetail,
          extra: {
            'item': item,
            "restaurant": restaurant,
            "currencyCode": currencyCode,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .6.h),
        margin: EdgeInsets.symmetric(vertical: .8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey200,
              offset: Offset(1, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl!,
                width: 29.sp,
                height: 29.sp,
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
                      AppLocalizations.of(context)!.loadImageError,
                      textAlign: TextAlign.center,
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 2.w,
                    ),
                    child: Text(
                      '${item.price} $currencyCode',
                      style: GoogleFonts.sen(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                        color: const Color(0xffff3008),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: .6.h, horizontal: 2.w),
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
                        context.read<CartCubit>().removeFromCart(item);
                        context.read<TotalPriceBloc>().add(
                              GetOrderTotalPriceEvent(
                                cart: cartCubit.state,
                              ),
                            );
                      },
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor:
                            context.read<CartCubit>().isItemInCart(item)
                                ? const Color(0xffFF3008)
                                : Colors.white,
                        child: SvgPicture.asset(
                          "assets/icons/minus.svg",
                          fit: BoxFit.scaleDown,
                          height: 25.sp,
                          width: 25.sp,
                          colorFilter: ColorFilter.mode(
                            !context.read<CartCubit>().isItemInCart(item)
                                ? const Color(0xffFF3008)
                                : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      context.read<CartCubit>().getItemCount(item).toString(),
                      style: GoogleFonts.sen(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    InkWell(
                      onTap: () {
                        context.read<CartCubit>().addToCart(item);
                        context.read<TotalPriceBloc>().add(
                              GetOrderTotalPriceEvent(
                                cart: cartCubit.state,
                              ),
                            );
                      },
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: const Color(0xffFF3008),
                        child: SvgPicture.asset(
                          "assets/icons/plus_2.svg",
                          fit: BoxFit.scaleDown,
                          height: 25.sp,
                          width: 25.sp,
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
          ],
        ),
      ),
    );
  }
}
