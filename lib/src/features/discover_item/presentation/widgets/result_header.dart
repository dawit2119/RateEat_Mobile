import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResultHeader extends StatelessWidget {
  final String name;
  final VoidCallback searchTap;
  final VoidCallback filterTap;
  const ResultHeader(
      {super.key,
      required this.name,
      required this.searchTap,
      required this.filterTap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [...elevation_8],
                  borderRadius: BorderRadius.circular(10)),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: filterTap,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset("assets/icons/Filter.svg"),
                  ),
                ),
              ),
            ),
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                // Changed from RectDottedBorderOptions
                padding: EdgeInsets.zero,
                // borderType removed - not needed
                color: AppColors.primaryColor,
                dashPattern: const [6],
                radius: const Radius.circular(11), // Now works correctly
                strokeWidth: 2,
              ),
              child: SizedBox(
                  width: screenWidth * 0.54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 7, 5),
                          child: Icon(
                            Icons.gps_not_fixed,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        horizontalPadding(width: 1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: subTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    fontSize: 12),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [...elevation_4],
                  borderRadius: BorderRadius.circular(10)),
              width: screenWidth * 0.13,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: searchTap,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset("assets/icons/search.svg"),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
