import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'restaurant_phone_number.g.dart';

@HiveType(typeId: 13)
class RestaurantPhoneNumber extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? phoneNumber;

  const RestaurantPhoneNumber({this.id, this.phoneNumber});

  factory RestaurantPhoneNumber.fromJson(Map<String, dynamic> data) {
    return RestaurantPhoneNumber(
      id: data['id'] as String?,
      phoneNumber: data['phone_number'] as String?,
    );
  }

  RestaurantPhoneNumber copyWith({
    String? id,
    String? phoneNumber,
  }) {
    return RestaurantPhoneNumber(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [id, phoneNumber];
}
