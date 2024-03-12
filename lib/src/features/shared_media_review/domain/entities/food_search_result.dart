import 'package:equatable/equatable.dart';

class FoodSearchResult extends Equatable {
  final String? id;
  final String? name;
  final String? imageUri;

  const FoodSearchResult({this.id, this.name, this.imageUri});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, imageUri];
}
