import 'dart:io';

class PriceChangeRequest {
  final String restaurantId;
  final String? description;
  final List<File> images;

  PriceChangeRequest(
      {required this.restaurantId, this.description, required this.images});

  PriceChangeRequest copyWith(
      {String? restaurantId, String? description, List<File>? images}) {
    return PriceChangeRequest(
        restaurantId: restaurantId ?? this.restaurantId,
        images: images ?? this.images,
        description: description ?? this.description);
  }
}
