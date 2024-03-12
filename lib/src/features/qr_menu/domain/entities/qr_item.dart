import 'package:equatable/equatable.dart';

class QRItem extends Equatable {
  final String categoryId;
  final String name;
  final double rating;
  final int price;
  final int numberOfReviews;
  final String id;
  final String imageUrl;
  final bool isFasting;
  const QRItem(
      {required this.categoryId,
      required this.name,
      required this.rating,
      required this.price,
      required this.numberOfReviews,
      required this.id,
      required this.imageUrl,
      required this.isFasting});
  @override
  List<Object?> get props => [
        categoryId,
        name,
        rating,
        price,
        numberOfReviews,
        id,
        imageUrl,
        isFasting
      ];
}
