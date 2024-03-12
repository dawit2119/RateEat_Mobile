class FormMessages {
  // Form Error
  static RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String emailNullError = "Please Enter your email";
  static const String invalidEmailError = "Please Enter Valid Email";
  static const String passNullError = "Please Enter your password";
  static const String shortPassError = "Password is too short";
  static const String matchPassError = "Passwords don't match";
  static const String fristNameNullError = "Please Enter your firstname";
  static const String lastNameNullError = "Please Enter your lastname";
  static const String phoneNumberNullError = "Please Enter your phonenumber";
  static const String addressNullError = "Please Enter your address";
}
