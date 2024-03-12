class SearchResultModel {
  bool success;
  List<Restaurant> restaurants;
  List<Item> items;

  SearchResultModel({
    required this.success,
    required this.restaurants,
    required this.items,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        success: json["success"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );
}

class Item {
  String id;
  String name;
  String description;
  int numberOfReviews;
  int averageRating;
  double price;
  String categoryId;
  bool fasting;
  int popularityIndex;
  DateTime createdAt;
  DateTime updatedAt;
  List<Tag> itemTags;

  Item({
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
    required this.itemTags,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        numberOfReviews: json["number_of_reviews"],
        averageRating: json["average_rating"],
        price: json["price"].toDouble(),
        categoryId: json["category_id"],
        fasting: json["fasting"],
        popularityIndex: json["popularity_index"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        itemTags: List<Tag>.from(json["item_tags"].map((x) => Tag.fromJson(x))),
      );
}

class Tag {
  String id;
  String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
      );
}

class Restaurant {
  String id;
  String name;
  String openingHour;
  String closingHour;
  bool isOpen;
  int averagePrice;
  int averageRating;
  int numberOfReviews;
  int popularityIndex;
  dynamic userId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Tag> restaurantTags;

  Restaurant({
    required this.id,
    required this.name,
    required this.openingHour,
    required this.closingHour,
    required this.isOpen,
    required this.averagePrice,
    required this.averageRating,
    required this.numberOfReviews,
    required this.popularityIndex,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurantTags,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        openingHour: json["opening_hour"],
        closingHour: json["closing_hour"],
        isOpen: json["is_open"],
        averagePrice: json["average_price"],
        averageRating: json["average_rating"],
        numberOfReviews: json["number_of_reviews"],
        popularityIndex: json["popularity_index"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        restaurantTags:
            List<Tag>.from(json["restaurant_tags"].map((x) => Tag.fromJson(x))),
      );
}
