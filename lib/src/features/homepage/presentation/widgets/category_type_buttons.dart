import 'package:flutter/material.dart';

class CategoryTypeButton extends StatefulWidget {
  final String itemType;
  const CategoryTypeButton({super.key, required this.itemType});

  @override
  State<CategoryTypeButton> createState() => _CategoryTypeButtonState();
}

class _CategoryTypeButtonState extends State<CategoryTypeButton> {
  bool isSelected = false;
  Color bgColor = const Color(0xFFFBFCFF);
  Color textColor = Colors.black;
  Size maximumSize = const Size(64, 36);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              isSelected = !isSelected;
            });
            if (isSelected) {
              setState(() {
                bgColor = const Color(0xFFFF3008);
                textColor = Colors.white;
              });
            } else {
              setState(() {
                bgColor = const Color(0xFFFBFCFF);
                textColor = Colors.black;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            elevation: 0,
            padding: const EdgeInsets.all(7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
          ),
          child: Text(
            widget.itemType,
            style: TextStyle(color: textColor, fontSize: 14),
          )),
    );
  }
}
