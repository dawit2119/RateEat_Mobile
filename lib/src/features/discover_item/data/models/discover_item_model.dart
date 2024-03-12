class DiscoverItemModel {
  final double? maxPrice;
  final double? minRating;
  DiscoverItemModel({this.maxPrice, this.minRating});

  DiscoverItemModel copyWith({double? maxPrice, double? minRating}) {
    return DiscoverItemModel(
        maxPrice: maxPrice ?? this.maxPrice,
        minRating: minRating ?? this.minRating);
  }
}
