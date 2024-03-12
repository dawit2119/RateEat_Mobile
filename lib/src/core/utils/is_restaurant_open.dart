import 'package:intl/intl.dart';

bool isRestaurantOpen(
    {required String? openingHour, required String? closingHour}) {
  if (openingHour == null || closingHour == null) return false;
  DateFormat formatter = DateFormat('HH:mm:ss');
  DateTime now = DateTime.now();
  DateTime? openingTime = formatter.parse(openingHour);
  DateTime? closingTime = formatter.parse(closingHour);

  // Get today's date at midnight to avoid date components interfering with the comparison
  DateTime todayMidnight = DateTime(now.year, now.month, now.day);

  // Add the parsed time components to today's date
  openingTime = todayMidnight.add(
    Duration(hours: openingTime.hour, minutes: openingTime.minute),
  );
  closingTime = todayMidnight.add(
    Duration(hours: closingTime.hour, minutes: closingTime.minute),
  );
  return now.isAfter(openingTime) && now.isBefore(closingTime);
}
