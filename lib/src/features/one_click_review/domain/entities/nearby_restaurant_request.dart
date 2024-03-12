class NearByRestaurantRequest {
  final double latitude;
  final double longitude;
  final double radius;
  final String? searchQuery;
  final int page;
  final int? limit;

  NearByRestaurantRequest({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.page,
    this.searchQuery,
    this.limit,
  });
}
