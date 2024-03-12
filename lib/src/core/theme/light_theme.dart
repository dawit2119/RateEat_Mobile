import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.appColor,
  primaryColorLight: AppColors.appColor,
  primarySwatch: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.appColor,
    selectionColor: Color.fromARGB(255, 129, 141, 230),
  ),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
  useMaterial3: true,
);
