import 'package:equatable/equatable.dart';

class NotificationReactor extends Equatable {
  final String firstName;
  final String lastName;
  final String profileImageUrl;

  const NotificationReactor({
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });
  @override
  List<Object?> get props => [
        firstName,
        lastName,
        profileImageUrl,
      ];
}
