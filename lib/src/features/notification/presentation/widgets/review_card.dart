import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../../authentication/authentication.dart';
import '../../domain/entities/item_review.dart';
import '../../domain/entities/notification.dart';

class ReviewCard extends StatelessWidget {
  final TargetReview? itemReview;
  final NotificationEntity notification;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  ReviewCard({
    super.key,
    this.itemReview,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var user = dpLocator<AuthenticationLocalSource>().getUserCredential();

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.006,
          horizontal: screenWidth * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: notification.notifiableType ==
                          NotificationType.favoriteItem
                      ? notification.reactor.profileImageUrl.isNotEmpty
                          ? notification.reactor.profileImageUrl
                          : "https://storage.googleapis.com/rateeat_bucket/RateEat/ProfileImages/1701090706034.jpg"
                      : user!.image != null
                          ? user.image!
                          : "https://storage.googleapis.com/rateeat_bucket/RateEat/ProfileImages/1701090706034.jpg",
                  memCacheHeight: (35).cacheSize(context),
                  memCacheWidth: (35).cacheSize(context),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                  ),
                ),
              ),
            ),
            horizontalPadding(width: 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${notification.notifiableType == NotificationType.favoriteItem ? notification.reactor.firstName : user!.firstName} ${notification.notifiableType == NotificationType.favoriteItem ? notification.reactor.lastName : user!.lastName ?? ""}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500,
                                fontSize: screenHeight * 0.014,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.005),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                      itemReview != null
                                          ? itemReview!.createdAt
                                          : DateTime.now(),
                                    ),
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic,
                                      fontSize: screenHeight * 0.012,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) {
                                      return SvgPicture.asset(
                                        "assets/icons/star_full_rounded.svg",
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      );
                                    },
                                    itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    unratedColor: AppColors.grey200,
                                    itemSize: screenHeight * 0.0115,
                                    itemCount: 5,
                                    rating: itemReview != null
                                        ? itemReview!.rating
                                        : 3.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalPadding(height: 1),
                  // *Comment Section
                  Text(
                    itemReview != null ? itemReview!.comment : "Nice Review",
                    style: GoogleFonts.poppins(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      fontSize: screenHeight * 0.015,
                    ),
                  ),

                  verticalPadding(height: .4),
                  // *Images Section
                  // userReview.images!.isNotEmpty
                  //     ? ReviewStackImage(imageURLs: userReview.images!)
                  //     : Container(),
                  verticalPadding(height: .4),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  verticalPadding(height: .8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
