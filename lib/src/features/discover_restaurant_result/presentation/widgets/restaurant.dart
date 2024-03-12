import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class RestaurantCard extends StatelessWidget {
  final String id;
  final double rating;
  final String location;
  final String restaurantName;
  final int noOfReviews;
  final int walkingTime;
  final bool isOpen;
  final List<String> tags;
  const RestaurantCard({
    super.key,
    required this.id,
    required this.rating,
    required this.location,
    required this.restaurantName,
    required this.noOfReviews,
    required this.walkingTime,
    required this.isOpen,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Container(
        height: screenHeight * 0.136,
        width: screenWidth,
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
              blurRadius: 10,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.pushNamed(
                AppRoutes.restaurantDetail,
                pathParameters: {'restaurantId': id},
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -5,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.textDark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              color: Colors.white,
                              size: 17,
                            ),
                            Text(
                              "$walkingTime Min",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                restaurantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff24292e),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          (isOpen) ? Colors.green : Colors.red),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: (isOpen)
                                    ? Container(
                                        width: screenWidth * 0.1,
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .openText,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: screenWidth * 0.1,
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .closedText,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.paperplane,
                            size: 18,
                            color: Color(0xFFFF3008),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            width: screenWidth * 0.7,
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.03,
                            bottom: screenHeight * 0.01,
                            top: screenHeight * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tags.isNotEmpty
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          tags.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final tag = entry.value;
                                        return Row(
                                          children: [
                                            Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff24292e),
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.01),
                                            if (index <
                                                tags.length -
                                                    1) // Add dot if not the last item
                                              Icon(
                                                Icons.fiber_manual_record,
                                                size: screenHeight *
                                                    0.008, // Set the desired dot size
                                                color: const Color(0xff24292e),
                                              ),
                                            SizedBox(width: screenWidth * 0.01),
                                          ],
                                        );
                                      }).toList(),
                                    ))
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.red,
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF3C404A),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "$rating/5",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                                const TextSpan(text: " • "),
                                TextSpan(
                                    text:
                                        "($noOfReviews ${AppLocalizations.of(context)!.ratingText})",
                                    style: const TextStyle(
                                        color: Color(0xFF586069))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
