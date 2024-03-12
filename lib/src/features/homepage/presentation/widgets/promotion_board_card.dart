import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PromotionBoardCard extends StatelessWidget {
  final String imageUrl;
  const PromotionBoardCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      child: SizedBox(
        height: screenHeight * 0.17,
        width: screenWidth * 0.8,
        child: Card(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chicken Salad",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.027),
                    ),
                    const Text("Amrogn Chicken"),
                    SizedBox(height: screenHeight * 0.01),
                    const Text(
                      "60% OFF",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    SizedBox(
                      height: screenHeight * 0.03,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text(
                          "GO TO ITEM",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 15.h,
                  width: 30.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
