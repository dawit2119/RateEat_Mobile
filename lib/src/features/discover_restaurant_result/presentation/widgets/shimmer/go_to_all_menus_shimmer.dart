import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class GotoAllMenusShimmerCard extends StatelessWidget {
  const GotoAllMenusShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Container(
        height: screenHeight * 0.23,
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white10,
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textDark,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: ShimmerContainer(
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
              verticalPadding(height: 1.5),
              const ShimmerContainer(
                width: 60,
                height: 15,
              ),
              verticalPadding(height: 1.5),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 4,
                ),
                child: ShimmerContainer(
                  width: 60,
                  height: 20,
                ),
              ),
              verticalPadding(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
