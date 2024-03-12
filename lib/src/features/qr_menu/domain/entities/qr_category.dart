import 'package:equatable/equatable.dart';

abstract class QRCategory extends Equatable {
  final String id;
  final String name;
  final String imageUri;
  const QRCategory(
      {required this.id, required this.name, required this.imageUri});

  @override
  List<Object?> get props => [id, name, imageUri];
}
