import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appLaunchStateBox = Hive.box<bool>('appLaunchState');
    appLaunchStateBox.put(0, false);
    // onboardUser();

    return const Scaffold(
      body: Body(),
    );
  }
}
