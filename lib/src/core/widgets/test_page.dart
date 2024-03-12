import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/constants/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'updated_bottom_sheet.dart';

//! Page used for tasting widgets only
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
          height: 100.h,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Test page",
                  style: titleTextStyle,
                ),
              ),
            ],
          )),
      bottomNavigationBar: const UpdatedBottomNavigationBar(),
    );
  }
}
