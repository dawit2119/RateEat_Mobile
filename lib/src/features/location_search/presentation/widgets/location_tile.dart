import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';

import '../../../../core/constants/constants.dart';

class LocationTile extends StatelessWidget {
  final VoidCallback onPress;
  final GoogleAutoCompleteModel location;

  const LocationTile(
      {super.key, required this.location, required this.onPress});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.065,
      margin: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 0), // Customize horizontal padding
        onTap: onPress,
        title: Row(
          children: [
            Icon(
              Icons.location_searching_outlined,
              size: screenHeight * 0.017,
              color: Colors.black.withOpacity(0.7),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                location.description,
                maxLines: 1,
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        subtitle: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.grey200,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Text(
                  maxLines: 1,
                  location.description,
                  style: TextStyle(
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
