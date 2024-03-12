import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class LeaderCard extends StatelessWidget {
  final String name;
  final String points;
  final String rank;
  final String imageUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final GestureTapCallback? onTap;

  const LeaderCard({
    super.key,
    required this.name,
    required this.points,
    required this.rank,
    this.backgroundColor,
    this.textColor,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ??
            ((int.parse(rank) % 2 == 0) ? Colors.white : Colors.grey[100]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                rank,
                style: GoogleFonts.plusJakartaSans(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 3.w),
              SizedBox(
                height: 5.h,
                width: 5.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (imageUrl ?? "").isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          memCacheHeight: (5.h).cacheSize(context),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                          ),
                        ),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                points,
                maxLines: 1,
                style: GoogleFonts.plusJakartaSans(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              points != ""
                  ? SizedBox(
                      width: 12.w,
                      child: Text(
                        AppLocalizations.of(context)!.pointsText.toLowerCase(),
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15.sp, color: AppColors.grey400),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
