import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_review.dart';

class ReviewSubjectModel extends ReviewSubject {
  const ReviewSubjectModel({
    super.id,
    super.name,
    super.isItem,
    super.imageUrl,
    super.itemImages,
    super.itemVideos,
  });

  factory ReviewSubjectModel.fromMap(Map<String, dynamic> data, isItem) =>
      ReviewSubjectModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        isItem: isItem,
        imageUrl: isItem
            ? ((data['item_images'] != null && data['item_images'].isNotEmpty)
                ? data['item_images'][0]['url']
                : "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg")
            : ((data['restaurant_images'] != null &&
                    data['restaurant_images'].isNotEmpty)
                ? data['restaurant_images'][0]['url']
                : "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
        itemImages: isItem
            ? (data['item_images'] as List<dynamic>?)
                ?.map(
                    (e) => ReviewMediaModel.fromMap(e as Map<String, dynamic>))
                .toList()
            : (data['restaurant_images'] as List<dynamic>?)
                ?.map(
                    (e) => ReviewMediaModel.fromMap(e as Map<String, dynamic>))
                .toList(),
        itemVideos: isItem
            ? (data['item_videos'] as List<dynamic>?)
                ?.map(
                    (e) => ReviewMediaModel.fromMap(e as Map<String, dynamic>))
                .toList()
            : (data['restaurant_videos'] as List<dynamic>?)
                ?.map(
                    (e) => ReviewMediaModel.fromMap(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isItem': isItem,
        'image_url': imageUrl,
        'item_images': itemImages,
        'item_videos': itemVideos,
      };
}
