import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterCheckBox extends StatefulWidget {
  final String title;
  const FilterCheckBox({super.key, required this.title});

  @override
  State<FilterCheckBox> createState() => _FilterCheckBoxState();
}

class _FilterCheckBoxState extends State<FilterCheckBox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
              activeColor: AppColors.primaryColor,
              value: isChecked,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp)),
              side: WidgetStateBorderSide.resolveWith(
                (states) => BorderSide(
                  width: 1.0,
                  color: (isChecked)
                      ? AppColors.primaryColor
                      : DefaultSelectionStyle.defaultColor,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              }),
        ),
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.textDark,
          ),
        ),
      ],
    ));
  }
}
