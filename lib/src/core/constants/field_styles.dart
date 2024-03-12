import 'package:flutter/material.dart';

import 'constants.dart';

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(
    vertical: 15,
  ),
  enabledBorder: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  border: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: AppColors.textColor),
  );
}
