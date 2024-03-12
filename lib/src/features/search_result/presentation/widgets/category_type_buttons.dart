import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class CategoryTypeButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final GestureTapCallback onPressed;
  const CategoryTypeButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.primaryButtonColor : AppColors.grey100,
          elevation: 0,
          padding: const EdgeInsets.all(7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.secondaryColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
