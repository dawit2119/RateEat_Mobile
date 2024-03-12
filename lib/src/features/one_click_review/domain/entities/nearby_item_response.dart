import 'package:equatable/equatable.dart';

class NearByItemResponse extends Equatable {
  final String? id;
  final String? name;
  final String? imageUri;

  const NearByItemResponse({this.id, this.name, this.imageUri});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, imageUri];
}

// class NearByItemIngredients {
//   String id;
//   String name;
//   String? itemId;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   NearByItemIngredients({
//     required this.id,
//     required this.name,
//     this.itemId,
//     this.createdAt,
//     required this.updatedAt,
//   });
// }
