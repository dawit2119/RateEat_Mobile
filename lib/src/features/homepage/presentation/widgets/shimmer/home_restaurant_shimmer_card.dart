import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeRestaurantCard extends StatelessWidget {
  const ShimmerHomeRestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle onTap
      },
      child: Card(
        elevation: 1,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Stack(
              children: [
                // Shimmering Image Placeholder
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),

                // Shimmering Details Placeholder
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shimmering Name
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),

                        // Shimmering Rating
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 5),
                            Container(
                              width: 60,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 80,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Shimmering Location and Open/Closed
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Shimmering Location
                        Row(
                          children: [
                            const Icon(Icons.directions,
                                color: Colors.white, size: 25),
                            const SizedBox(width: 5),
                            Container(
                              width: 120,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),

                        // Shimmering Open/Closed
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 70,
                            height: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
