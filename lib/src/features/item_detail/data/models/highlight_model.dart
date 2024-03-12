import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

enum MediaType {
  image,
  video,
}

class HighlightModel {
  final String url;
  final MediaType media;
  final Duration duration;

  const HighlightModel({
    required this.url,
    required this.media,
    required this.duration,
  });
}

List<HighlightModel> mapToHighlightModels(
    List<dynamic> imageUrls, List<dynamic> videoUrls) {
  List<HighlightModel> highlightModels = [];

  for (var imageUrl in imageUrls) {
    highlightModels.add(HighlightModel(
      url: imageUrl is Map<String, dynamic>
          ? imageUrl['url']
          : imageUrl.url ??
              "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740",
      media: MediaType.image,
      duration: const Duration(seconds: 6), // Set duration as needed for images
    ));
  }
  if (videoUrls is List<RestaurantMedia> ||
      videoUrls is List<ItemMedia> ||
      videoUrls is List<ReviewMedia>) {
    videoUrls = videoUrls.map((video) => video.url).toList();
  }
  try {
    for (String videoUrl in videoUrls) {
      highlightModels.add(HighlightModel(
        url: videoUrl,
        media: MediaType.video,
        duration: const Duration(seconds: 0), // Set actual video duration here
      ));
    }
  } catch (e) {
    //failed to parse videos
  }

  if (highlightModels.isEmpty) {
    return [
      const HighlightModel(
        url:
            'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg',
        media: MediaType.image,
        duration: Duration(seconds: 6), // Set duration as needed for images
      ),
    ];
  }
  return highlightModels;
}
