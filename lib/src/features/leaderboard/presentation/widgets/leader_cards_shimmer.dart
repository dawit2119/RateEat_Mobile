import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListDisplay extends StatelessWidget {
  final int count;
  const ShimmerListDisplay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) {
          bool isOddIndex = index.isOdd;
          return Shimmer.fromColors(
            baseColor: isOddIndex ? Colors.grey[300]! : Colors.grey[200]!,
            highlightColor: isOddIndex ? Colors.grey[100]! : Colors.grey[300]!,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
              ),
              height: 70.0, // Adjust the height as needed
            ),
          );
        },
      ),
    );
  }
}
