import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
      .hasMatch(email.trim())) {
    return 'Invalid email format';
  }

  return null;
}

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Phone number is required';
  } else if (!RegExp(r'^[0-9]{9}$').hasMatch(phoneNumber)) {
    return 'Invalid phone number format';
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }

  return null;
}

bool validateIsImage(String imageUrl) {
  return RegExp(r'\.(jpeg|jpg|png|gif)').hasMatch(imageUrl);
}

bool validateAndShowToast({
  required BuildContext context,
  required String phone,
  String? gender,
}) {
  if (phone.isEmpty) {
    showCustomToast(
      context: context,
      toastMessage: "Phone number can't be empty",
      toastType: ToastType.error,
    );
    return false;
  }

  if (gender == null || gender.isEmpty) {
    showCustomToast(
      context: context,
      toastMessage: "Please select gender",
      toastType: ToastType.error,
    );
    return false;
  }
  return true;
}
