import 'dart:io';

class ItemPriceChangeRequest {
  final String itemId;
  final String? description;
  final double? price;

  ItemPriceChangeRequest(
      {required this.itemId, this.description, required this.price});

  ItemPriceChangeRequest copyWith(
      {String? itemId, String? description, List<File>? images}) {
    return ItemPriceChangeRequest(
        itemId: itemId ?? this.itemId,
        price: price ?? price,
        description: description ?? this.description);
  }
}
