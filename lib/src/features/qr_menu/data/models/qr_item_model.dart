import 'package:rateeat_mobile/src/features/qr_menu/domain/domain.dart';

class QRItemModel extends QRItem {
  const QRItemModel(
      {required super.categoryId,
      required super.name,
      required super.rating,
      required super.price,
      required super.numberOfReviews,
      required super.id,
      required super.imageUrl,
      required super.isFasting});

  factory QRItemModel.fromMap(Map<String, dynamic> json) => QRItemModel(
        categoryId: json["category_id"] ?? "",
        isFasting: json["fasting"] ?? false,
        name: json["name"] ?? "",
        rating: json["average_rating"] != null && json["average_rating"] is int
            ? (json["average_rating"] as int).toDouble()
            : (json["average_rating"] is double ? json["average_rating"] : 0.0),
        price: json["price"] ?? 0,
        numberOfReviews: json["number_of_reviews"] ?? 0,
        id: json["id"] ?? "",
        imageUrl: json["item_images"] != null && json["item_images"].length > 0
            ? json["item_images"][0]["url"]
            : "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1734682325169-high.webp",
      );
}
