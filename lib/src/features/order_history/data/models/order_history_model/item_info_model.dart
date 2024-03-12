import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

class ItemInfoModel extends ItemInfoEntity {
  const ItemInfoModel({super.name, super.price, super.imageUrl});

  factory ItemInfoModel.fromMap(Map<String, dynamic> data) {
    var itemInfoModel = ItemInfoModel(
      name: data['name'] as String?,
      price: data['price'] as int?,
      imageUrl: (data['item_images'] != null &&
              data['item_images'].isNotEmpty &&
              data['item_images'][0]["url"] != null)
          ? data['item_images'][0]["url"]
          : "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
    );
    return itemInfoModel;
  }

  @override
  List<Object?> get props => [name, price, imageUrl];
}
