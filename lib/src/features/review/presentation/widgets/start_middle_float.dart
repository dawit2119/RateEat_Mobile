import 'package:flutter/material.dart';

class StartMiddleFloat extends FloatingActionButtonLocation {
  const StartMiddleFloat();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX =
        scaffoldGeometry.minInsets.left + 16.0; // Distance from left edge
    final double fabY = (scaffoldGeometry.scaffoldSize.height -
            scaffoldGeometry.floatingActionButtonSize.height) /
        2; // Middle of the screen vertically
    return Offset(fabX, fabY);
  }
}
