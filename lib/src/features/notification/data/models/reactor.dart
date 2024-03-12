import 'package:rateeat_mobile/src/features/notification/domain/entities/reactor.dart';

class NotificationReactorModel extends NotificationReactor {
  const NotificationReactorModel({
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
  });

  factory NotificationReactorModel.fromMap(Map<String, dynamic> json) =>
      NotificationReactorModel(
        firstName: json['first_name'] ?? "",
        lastName: json["last_name"] ?? "",
        profileImageUrl: json['image'] ?? "",
      );
}
