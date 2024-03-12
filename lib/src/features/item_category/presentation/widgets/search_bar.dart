import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController controller;
  const CustomSearchBar(
      {super.key, required this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search Food Type',
            hintStyle: searchHintTextStyle,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.location_searching),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
