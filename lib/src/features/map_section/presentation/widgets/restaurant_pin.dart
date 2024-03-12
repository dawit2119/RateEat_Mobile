import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantLocationPin extends StatelessWidget {
  const RestaurantLocationPin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(40, 40), // Set the size of the pin
      child: SvgPicture.asset("/assets/icons/restaurant_location_pin.svg"),
    );
  }
}
