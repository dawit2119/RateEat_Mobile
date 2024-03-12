import '../../domain/entities/item_review.dart';

class TargetReviewModel extends TargetReview {
  const TargetReviewModel({
    required super.id,
    required super.notifiableId,
    required super.userId,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.imageUrl,
  });

  factory TargetReviewModel.fromMap(Map<String, dynamic> json) {
    return TargetReviewModel(
      id: json['id'],
      notifiableId: json['item_id'] ?? json['restaurant_id'],
      userId: json['user_id'],
      rating: json['rating'].toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
      imageUrl: json['item_image'] ?? json['restaurant_image'],
    );
  }
}
