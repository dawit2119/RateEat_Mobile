import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class ItemResultHeader extends StatelessWidget {
  final String path;
  final VoidCallback onTap;
  const ItemResultHeader({super.key, required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        height: SizeConfig.screenHeight * 0.059,
        width: SizeConfig.screenHeight * 0.059,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [...elevation_4],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(
            path,
          ),
        ),
      ),
    );
  }
}
