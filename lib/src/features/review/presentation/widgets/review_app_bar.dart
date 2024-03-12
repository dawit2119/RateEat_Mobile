import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class ReviewAppBar extends StatelessWidget {
  final String title;
  const ReviewAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.06),
      margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.05,
                width: SizeConfig.screenHeight * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              //* Title
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: SizeConfig.screenHeight * 0.021,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
