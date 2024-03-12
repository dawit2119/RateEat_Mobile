import 'package:image_picker/image_picker.dart';

class DraftReviewRequest {
  final String itemId;
  final String restaurantId;
  final List<XFile>? images;
  final List<XFile>? videos;

  DraftReviewRequest({
    required this.itemId,
    required this.restaurantId,
    this.images,
    this.videos,
  });

  DraftReviewRequest copyWith({
    String? itemId,
    String? restaurantId,
    List<XFile>? images,
    List<XFile>? videos,
  }) {
    return DraftReviewRequest(
      itemId: itemId ?? this.itemId,
      restaurantId: restaurantId ?? this.restaurantId,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
