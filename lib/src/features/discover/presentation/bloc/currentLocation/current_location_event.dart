import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';

class UserLocationEvent extends Equatable {
  const UserLocationEvent();

  @override
  List<Object> get props => [];
}

class GetUserLocation extends UserLocationEvent {
  const GetUserLocation();
}

class ChangeUserLocation extends UserLocationEvent {
  final Location newLocation;

  const ChangeUserLocation({required this.newLocation});

  @override
  List<Object> get props => [newLocation];
}
