import 'package:hive/hive.dart';

import '../../item_category.dart';

abstract class LocalItemCategoryDataProvider {
  Future<void> cacheItemCategories(List<ItemCategory> itemCategories);
  Future<List<ItemCategory>> getItemCategories();
  Future<void> clearItemCategories();
}

class LocalItemCategoryDataProviderImpl extends LocalItemCategoryDataProvider {
  late final Box<ItemCategory> itemCategoryBox;

  LocalItemCategoryDataProviderImpl({Box<ItemCategory>? itemCategoryBox}) {
    if (itemCategoryBox != null) {
      this.itemCategoryBox = itemCategoryBox;
    } else {
      this.itemCategoryBox = Hive.box<ItemCategory>("itemCategoryListBox");
    }
  }

  @override
  Future<List<ItemCategory>> getItemCategories() async {
    return itemCategoryBox.values.toList(); // Retrieve all item categories
  }

  @override
  Future<void> cacheItemCategories(List<ItemCategory> itemCategories) async {
    for (var itemCategory in itemCategories) {
      await itemCategoryBox.add(itemCategory); // Add individual item categories
    }
  }

  @override
  Future<void> clearItemCategories() async {
    await itemCategoryBox.clear(); // Clear all entries in the box
  }
}
