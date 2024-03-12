import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class PriceButton extends StatefulWidget {
  final String price;
  final bool isSelected;
  final VoidCallback onSelected;

  const PriceButton({
    super.key,
    required this.price,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<PriceButton> createState() => _PriceButtonState();
}

class _PriceButtonState extends State<PriceButton> {
  Color get bgColor =>
      widget.isSelected ? AppColors.primaryColor : AppColors.grayLight;
  Color get fgColor => widget.isSelected ? Colors.white : AppColors.grey500;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onSelected();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(widget.price),
    );
  }
}
