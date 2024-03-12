import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    textMultiplier = blockSizeVertical;
    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;
  }

  static double getHorizontalSpacing(double percentageOfScreenWidth) {
    return blockSizeHorizontal * percentageOfScreenWidth;
  }

  static double getVerticalSpacing(double percentageOfScreenHeight) {
    return blockSizeVertical * percentageOfScreenHeight;
  }

  static double getFontSize(double percentageOfScreenHeight) {
    return textMultiplier * percentageOfScreenHeight;
  }
}

Widget verticalPadding({required double height}) => SizedBox(
      height: SizeConfig.getVerticalSpacing(height),
    );
Widget horizontalPadding({required double width}) => SizedBox(
      width: SizeConfig.getVerticalSpacing(width),
    );

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
