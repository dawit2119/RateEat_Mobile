import 'dart:io';

class CandidRestaurant {
  final String name;
  final String? description;
  final List<File> menuImages;
  final List<File>? restImages;
  CandidRestaurant(
      {required this.name,
      this.description,
      required this.menuImages,
      this.restImages});

  CandidRestaurant copyWith(
      {required String name,
      String? description,
      required List<File> menuImages,
      List<File>? restImages}) {
    return CandidRestaurant(
        name: name,
        description: description ?? this.description,
        menuImages: menuImages,
        restImages: restImages ?? this.restImages);
  }
}
