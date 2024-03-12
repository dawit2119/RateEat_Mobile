import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class UserFavoriteCard extends StatelessWidget {
  const UserFavoriteCard({
    super.key,
    required this.userFavorite,
  });

  final UserFavorite userFavorite;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.4,
        child: GestureDetector(
          onTap: () {
            if (userFavorite.item != null) {
              context.pushNamed(
                AppRoutes.itemDetail,
                pathParameters: {"itemId": userFavorite.item!.id!},
              );
            } else {
              context.pushNamed(
                AppRoutes.restaurantDetail,
                pathParameters: {"restaurantId": userFavorite.restaurant!.id!},
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: elevation_4,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 10.h,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: CachedNetworkImage(
                            imageUrl: userFavorite.item?.imageUrl! ??
                                userFavorite.restaurant!.imageUrl!,
                            memCacheWidth: (10.h).cacheSize(context),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 4.5.h,
                        width: 4.5.h,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            color: Colors.black.withOpacity(0.6)),
                        child: Center(
                          child: Icon(
                            size: 2.h,
                            userFavorite.item != null
                                ? Icons.fastfood_outlined
                                : Iconsax.shop,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          userFavorite.item?.name! ??
                              userFavorite.restaurant!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      verticalPadding(height: .5),
                      Text(
                        DateFormat('MMMM d, y').format(userFavorite.createdAt!),
                        style: streetTextStyle.copyWith(fontSize: 15.sp),
                      ),
                      verticalPadding(height: 1),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/star_full_rounded.svg",
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                            height: 2.4.h,
                            width: 2.4.h,
                          ),
                          horizontalPadding(width: .5),
                          Text(
                            '${userFavorite.item?.averageRating ?? userFavorite.restaurant!.averageRating} / 5',
                            style: streetTextStyle.copyWith(fontSize: 14.sp),
                          ),
                          horizontalPadding(width: 1),
                          Expanded(
                            child: Text(
                              '(${userFavorite.item?.ratingCount ?? userFavorite.restaurant!.numberOfReviews} ${AppLocalizations.of(context)!.revText})',
                              overflow: TextOverflow.ellipsis,
                              style: streetTextStyle.copyWith(fontSize: 14.sp),
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
        ));
  }
}
