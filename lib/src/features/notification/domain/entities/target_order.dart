import 'package:equatable/equatable.dart';

abstract class TargetOrder extends Equatable {
  final String? id;
  final String? restaurantId;

  const TargetOrder({required this.id, required this.restaurantId});

  @override
  List<Object?> get props => [
        id,
        restaurantId,
      ];
}
