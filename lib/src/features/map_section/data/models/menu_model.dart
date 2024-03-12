// import 'dart:convert';

// import 'package:collection/collection.dart';

// import '../../../features.dart';
// import '../../domain/domain.dart';

// class MenuModel extends Menu {
//   const MenuModel({
//     super.id,
//     super.restaurantId,
//     super.createdAt,
//     super.updatedAt,
//   });

//   @override
//   String toString() {
//     return 'MenuModel(id: $id, restaurantId: $restaurantId, createdAt: $createdAt, updatedAt: $updatedAt)';
//   }

//   factory MenuModel.fromFromJson(Map<String, dynamic> data) => MenuModel(
//         id: data['id'] as String?,
//         restaurantId: data['restaurant_id'] as String?,
//         createdAt: data['createdAt'] == null
//             ? null
//             : DateTime.parse(data['createdAt'] as String),
//         updatedAt: data['updatedAt'] == null
//             ? null
//             : DateTime.parse(data['updatedAt'] as String),
//       );

//   Map<String, dynamic> toFromJson() => {
//         'id': id,
//         'restaurant_id': restaurantId,
//         'createdAt': createdAt?.toIso8601String(),
//         'updatedAt': updatedAt?.toIso8601String(),
//       };

//   /// `dart:convert`
//   ///
//   /// Parses the string and returns the resulting Json object as [MenuModel].
//   factory MenuModel.fromJson(String data) {
//     return MenuModel.fromFromJson(json.decode(data) as Map<String, dynamic>);
//   }

//   /// `dart:convert`
//   ///
//   /// Converts [MenuModel] to a JSON string.
//   String toJson() => json.encode(toFromJson());

//   MenuModel copyWith({
//     String? id,
//     String? restaurantId,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return MenuModel(
//       id: id ?? this.id,
//       restaurantId: restaurantId ?? this.restaurantId,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! MenuModel) return false;
//     final mapEquals = const DeepCollectionEquality().equals;
//     return mapEquals(other.toFromJson(), toFromJson());
//   }

//   @override
//   int get hashCode =>
//       id.hashCode ^
//       restaurantId.hashCode ^
//       createdAt.hashCode ^
//       updatedAt.hashCode;
// }
