import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class ItemSearchBar extends StatelessWidget {
  const ItemSearchBar({super.key});

  static final TextEditingController searchItemController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomTextInputField(
      hintText: "Search Location",
      fillColor: Colors.white,
      labelColor: AppColors.grey600,
      controller: searchItemController,
      validator: (value) {
        return null;
      },
    );
  }
}
