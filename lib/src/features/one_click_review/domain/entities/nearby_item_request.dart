class NearByItemRequest {
  final String restaurantId;
  final String itemName;
  final int page;
  final int? limit;

  NearByItemRequest({
    required this.restaurantId,
    required this.itemName,
    required this.page,
    this.limit,
  });
}
