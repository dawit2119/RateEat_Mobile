import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

Future<void> checkLocationStatus(BuildContext ctx) async {
  const checkInterval = Duration(seconds: 2);
  int maxAttempts = 10;
  int attempts = 0;

  while (attempts < maxAttempts) {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied && ctx.mounted) {
      Navigator.of(ctx).pop();
      return;
    }

    // Wait for the specified interval before checking again.
    await Future.delayed(checkInterval);
    attempts++;
  }
}

void showLocationPermissionDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationPermissionTitleText),
        content:
            Text(AppLocalizations.of(context)!.locationPermissionContentText),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
              if (context.mounted) {
                checkLocationStatus(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.openLocationSettingText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(AppLocalizations.of(context)!.closeText),
          ),
        ],
      );
    },
  );
}
