import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

class RatingDisplayBars extends StatelessWidget {
  final double averageRating;
  final int numberOfReviews;
  final List<int> data;
  final bool isOrdering;
  final Function()? onTap;
  const RatingDisplayBars({
    super.key,
    required this.averageRating,
    required this.numberOfReviews,
    required this.data,
    this.isOrdering = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.01),
        Card(
          elevation: 0,
          color: const Color(0xFFF8F8F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "$averageRating",
                              style: GoogleFonts.getFont('Poppins',
                                  color: const Color(0xff3e3e3e),
                                  fontSize: screenHeight * 0.023,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "/",
                              style: GoogleFonts.getFont('Poppins',
                                  color: const Color(0xff3e3e3e),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                            Text(
                              "5",
                              style: GoogleFonts.getFont('Poppins',
                                  color: const Color(0xff3e3e3e),
                                  fontSize: screenHeight * 0.023,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${AppLocalizations.of(context)!.basedOnText} $numberOfReviews ${AppLocalizations.of(context)!.revText}",
                          style: const TextStyle(
                              color: Color(0xFF6A737D), fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 5, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: averageRating,
                              ignoreGestures: true,
                              minRating: 1,
                              glowColor: const Color(0xFFB5BABE),
                              glowRadius: 0.1,
                              direction: Axis.horizontal,
                              onRatingUpdate: (rating) {},
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25,
                              unratedColor: const Color(0xFFDAD9D9),
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFF3008),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isOrdering)
                        InkWell(
                          onTap: onTap,
                          child: Container(
                            // margin: EdgeInsets.only(top: 1.h),
                            padding: const EdgeInsets.only(left: 8),

                            child: Text(
                              "See all reviews",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(
                                  0xffff3008,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 4),
                          child: Text(
                            (5 - index).toString(),
                            style: const TextStyle(
                                color: Color(0xFF6A737D), fontSize: 9),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                          child: SizedBox(
                            width: screenWidth * 0.25,
                            child: LinearProgressIndicator(
                              minHeight: 5,
                              value: data[4 - index] / numberOfReviews,
                              color: const Color(0xFFFF3008),
                              backgroundColor: const Color(0xFFE1E4E8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
