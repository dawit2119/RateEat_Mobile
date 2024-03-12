class FilterItem {
  String id;
  String name;
  String description;
  int numberOfReviews;
  int averageRating;
  int price;
  String categoryId;
  bool fasting;
  int popularityIndex;
  DateTime createdAt;
  DateTime updatedAt;
  List<Ingredient> ingredients;
  Categories categories;
  List<Ingredient> itemTags;

  FilterItem({
    required this.id,
    required this.name,
    required this.description,
    required this.numberOfReviews,
    required this.averageRating,
    required this.price,
    required this.categoryId,
    required this.fasting,
    required this.popularityIndex,
    required this.createdAt,
    required this.updatedAt,
    required this.ingredients,
    required this.categories,
    required this.itemTags,
  });

  factory FilterItem.fromJson(Map<String, dynamic> json) => FilterItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        numberOfReviews: json["number_of_reviews"],
        averageRating: json["average_rating"],
        price: json["price"],
        categoryId: json["category_id"],
        fasting: json["fasting"],
        popularityIndex: json["popularity_index"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        ingredients: List<Ingredient>.from(
            json["ingredients"].map((x) => Ingredient.fromJson(x))),
        categories: Categories.fromJson(json["categories"]),
        itemTags: List<Ingredient>.from(
            json["item_tags"].map((x) => Ingredient.fromJson(x))),
      );
}

class Categories {
  String id;
  String name;
  Menu menu;

  Categories({
    required this.id,
    required this.name,
    required this.menu,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        name: json["name"],
        menu: Menu.fromJson(json["menu"]),
      );
}

class Menu {
  String id;
  String restaurantId;
  DateTime createdAt;
  DateTime updatedAt;
  Ingredient restaurant;

  Menu({
    required this.id,
    required this.restaurantId,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurant,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        restaurantId: json["restaurant_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        restaurant: Ingredient.fromJson(json["restaurant"]),
      );
}

class Ingredient {
  String id;
  String name;

  Ingredient({
    required this.id,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        name: json["name"],
      );
}
