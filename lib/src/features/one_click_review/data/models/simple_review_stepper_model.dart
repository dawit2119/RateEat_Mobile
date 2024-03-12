import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

class SimpleAddReviewStepperModel extends Equatable {
  final List<XFile>? images;
  final List<XFile>? videos;
  final NearByItemResponse? item;
  final NearByRestaurantResponse? restaurant;

  const SimpleAddReviewStepperModel({
    this.item,
    this.images,
    this.videos,
    this.restaurant,
  });

  SimpleAddReviewStepperModel copyWith({
    List<XFile>? images,
    List<XFile>? videos,
    NearByItemResponse? item,
    NearByRestaurantResponse? restaurant,
  }) {
    return SimpleAddReviewStepperModel(
      item: item,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props => [
        images,
        videos,
        item,
        restaurant,
      ];
}
