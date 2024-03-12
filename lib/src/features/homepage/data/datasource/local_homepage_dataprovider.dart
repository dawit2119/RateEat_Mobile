import 'package:hive/hive.dart';

import '../../domain/entities/item.dart';

abstract class LocalHomepageDataprovider {
  Future<void> cacheTopRatedItems(List<Item> items);
  Future<List<Item>> getTopRatedItems();
  Future<void> clearTopRatedItems();
}

class LocalHomepageDataproviderImpl extends LocalHomepageDataprovider {
  late final Box<Item> itemBox;

  // optional parameter for testing (to inject mock item boxes)
  LocalHomepageDataproviderImpl({Box<Item>? itemBox}) {
    if (itemBox != null) {
      this.itemBox = itemBox;
    } else {
      this.itemBox = Hive.box<Item>("highestRatedItemsBox");
    }
  }

  @override
  Future<void> cacheTopRatedItems(List<Item> items) async {
    for (var item in items) {
      await itemBox.add(item);
    }
  }

  @override
  Future<void> clearTopRatedItems() async {
    await itemBox.clear();
  }

  @override
  Future<List<Item>> getTopRatedItems() async {
    return itemBox.values.toList();
  }
}
