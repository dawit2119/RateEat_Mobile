class Item {
  final String id;

  Item({required this.id});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Category {
  final String id;
  final String name;
  final bool isApproved;
  final String menuId;
  final String createdAt;
  final String updatedAt;
  final List<Item> item;
  final int totalItems;

  Category({
    required this.id,
    required this.name,
    required this.isApproved,
    required this.menuId,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
    required this.totalItems,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var itemList = json['item'] as List;
    List<Item> items = itemList.map((i) => Item.fromJson(i)).toList();

    return Category(
      id: json['id'],
      name: json['name'],
      isApproved: json['is_approved'],
      menuId: json['menu_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      item: items,
      totalItems: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_approved': isApproved,
      'menu_id': menuId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'item': item.map((i) => i.toJson()).toList(),
      'total_items': totalItems,
    };
  }
}

class CategoryModel {
  final bool success;
  final int allMenuItems;
  final List<Category> data;

  CategoryModel({
    required this.success,
    required this.allMenuItems,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Category> categories =
        dataList.map((d) => Category.fromJson(d)).toList();

    return CategoryModel(
      success: json['success'],
      allMenuItems: json['allMenuItems'],
      data: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'allMenuItems': allMenuItems,
      'data': data.map((c) => c.toJson()).toList(),
    };
  }
}
