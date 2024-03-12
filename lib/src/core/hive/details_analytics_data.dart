import 'package:hive/hive.dart';

part 'details_analytics_data.g.dart';

@HiveType(typeId: 0)
class DetailsAnalyticsData {
  @HiveField(0)
  String eventName;

  @HiveField(1)
  Set<String> eventData;

  DetailsAnalyticsData({required this.eventName, required this.eventData});

  DetailsAnalyticsData copyWith({
    String? eventName,
    Set<String>? eventData,
  }) {
    return DetailsAnalyticsData(
      eventName: eventName ?? this.eventName,
      eventData: eventData ?? this.eventData,
    );
  }
}

void sendStoredEventsInBackground() async {
  // final box = await Hive.openBox<DetailsAnalyticsData>('analytics_events');
  // final storedEvents = box.values.toList();

  // for (final event in storedEvents) {
  // Send the event to your backend
  // sendEventToBackend(event);

  // Remove the event from local storage after sending
  // box.delete(event.key);
  // }
}

Future<void> storeAnalyticsEvent(
    String eventName, Set<String> eventData) async {
  final box = await Hive.openBox<DetailsAnalyticsData>('analytics_events');
  final event =
      DetailsAnalyticsData(eventName: eventName, eventData: eventData);
  box.add(event);
}
