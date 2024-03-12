import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

final elevation_1 =
    // Elevation 2
    [
  BoxShadow(
    color: AppColors.grey300.withOpacity(.1),
    blurRadius: 12,
    spreadRadius: 0.0,
    offset: const Offset(0, 2),
  ),
];

final elevation_2 =
    // Elevation 2
    [
  BoxShadow(
    color: AppColors.grey300.withOpacity(.6),
    blurRadius: 4,
    spreadRadius: 0.0,
    offset: const Offset(0, 2),
  ),
];

final elevation_4 =
    // Elevation 4
    [
  BoxShadow(
    color: AppColors.grey200.withOpacity(.5),
    blurRadius: 4.0, // soften the shadow
    spreadRadius: .0, //extend the shadow
    offset: const Offset(2.0, 2.0),
  ),
  BoxShadow(
    color: AppColors.grey200.withOpacity(.5),
    blurRadius: 4.0, // soften the shadow
    spreadRadius: .0, //extend the shadow
    offset: const Offset(-2.0, -2.0),
  ),
];

final elevation_8 =
    // Elevation 8
    [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 8),
    blurRadius: 16,
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, -4),
    blurRadius: 16,
  ),
];

final elevation_16 =
    // Elevation 16
    [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 16),
    blurRadius: 32,
  ),
];

final elevation_32 =
    // Elevation 32
    [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 32),
    blurRadius: 64,
  ),
];

final whiteShadow = [
  BoxShadow(
    color: Colors.white.withOpacity(.3),
    offset: const Offset(0, 0),
    blurRadius: 20,
  ),
];
