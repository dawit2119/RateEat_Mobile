import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class QRMenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetQRMenu extends QRMenuEvent {
  final String restaurantId;
  final int page;
  final QRCategory? category;
  final bool? isFasting;
  final String? query;
  final String? sortBy;
  final String sortType;
  final int? minPrice;
  final int? maxPrice;
  final int? minRating;

  GetQRMenu(
      {required this.restaurantId,
      required this.page,
      required this.sortType,
      this.category,
      required this.isFasting,
      required this.query,
      required this.sortBy,
      required this.minPrice,
      required this.maxPrice,
      required this.minRating});
  @override
  List<Object?> get props => [
        restaurantId,
        page,
        category,
        isFasting,
        query,
        sortBy,
        sortType,
        minPrice,
        maxPrice,
        minRating
      ];
}
