import 'package:equatable/equatable.dart';

class NearByRestaurantResponse extends Equatable {
  final String? id;
  final String? name;
  final String? currency;

  const NearByRestaurantResponse({this.id, this.name, this.currency});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, currency];
}

// class NearByRestaurantLocation {
//   final String? id;
//   final double? latitude;
//   final double? longitude;
//   final String? description;

//   const NearByRestaurantLocation({
//     this.id,
//     this.latitude,
//     this.longitude,
//     this.description,
//   });

//   List<Object?> get props => [id, latitude, longitude, description];
// }

// class NearByRestaurantTag {
//   final String? id;
//   final String? name;

//   const NearByRestaurantTag({this.id, this.name});

//   List<Object?> get props => [id, name];
// }
