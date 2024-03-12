import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class FavoriteCard extends StatelessWidget {
  final String imageLink;
  final String itemName;
  final String price;
  final String categories;
  final String rating;
  final String totalReviews;

  const FavoriteCard({
    super.key,
    required this.imageLink,
    required this.itemName,
    required this.price,
    required this.categories,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: imageLink,
                      memCacheHeight: (12.h).cacheSize(
                        context,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 130,
                      child: Text(
                        categories,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0XFF868686)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xffff3008), size: 16),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '$rating /5',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            '$totalReviews (${AppLocalizations.of(context)!.reviewsText})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: AppColors.grey500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
