import 'package:rateeat_mobile/src/features/homepage/data/models/item_model.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import 'helper.dart';

List<ItemModel> dummyItems = [
  ItemModel(
    itemId: "1",
    itemName: "Margherita Pizza",
    numberOfReviews: 112,
    averageRating: 4.5,
    description:
        "Classic Margherita with homemade tomato sauce and mozzarella cheese.",
    restaurantName: "The Italian Corner",
    price: 8.99,
    imageUrl: "margherita_pizza.jpg",
    itemImages: [
      ItemMedia(
          id: '123',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    itemVideos: const [],
    tags: const ["Vegetarian", "Pizza"],
    categoryId: "1",
    fasting: false,
    createdAt: DateTime(2023, 1, 15),
    updatedAt: DateTime(2023, 1, 20),
    ingredients: const [],
    categories: const Categories(id: "1", name: "Italian", menuId: "1"),
    minutes: 15,
    isOpen: true,
    isFavorite: false,
    distance: "2.3 km",
    walkingTime: "30 mins",
    ridingTime: "10 mins",
  ),
  ItemModel(
    itemId: "2",
    itemName: "Vegan Burger",
    numberOfReviews: 85,
    averageRating: 4.8,
    description:
        "A delicious, fully vegan burger made with a beet and quinoa patty.",
    restaurantName: "Vegan Diner",
    price: 10.50,
    imageUrl: "vegan_burger.jpg",
    itemImages: [
      ItemMedia(
          id: '123',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    itemVideos: const [],
    tags: const ["Vegan", "Burger"],
    categoryId: "2",
    fasting: false,
    createdAt: DateTime(2023, 2, 10),
    updatedAt: DateTime(2023, 2, 15),
    ingredients: const [],
    categories: const Categories(id: "2", name: "Vegan", menuId: "2"),
    minutes: 10,
    isOpen: true,
    isFavorite: true,
    distance: "1.5 km",
    walkingTime: "20 mins",
    ridingTime: "5 mins",
  ),
  ItemModel(
    itemId: "3",
    itemName: "Spicy Ramen",
    numberOfReviews: 150,
    averageRating: 4.7,
    description:
        "Authentic Japanese ramen with a spicy kick, served with soft-boiled egg and bamboo shoots.",
    restaurantName: "Tokyo Ramen House",
    price: 12.99,
    imageUrl: "spicy_ramen.jpg",
    itemImages: [
      ItemMedia(
          id: '123',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    itemVideos: const [],
    tags: const ["Spicy", "Noodles", "Japanese"],
    categoryId: "3",
    fasting: false,
    createdAt: DateTime(2023, 3, 5),
    updatedAt: DateTime(2023, 3, 10),
    ingredients: const [],
    categories: const Categories(id: "3", name: "Japanese", menuId: "3"),
    minutes: 20,
    isOpen: true,
    isFavorite: true,
    distance: "3 km",
    walkingTime: "40 mins",
    ridingTime: "12 mins",
  ),
  ItemModel(
    itemId: "4",
    itemName: "Chicken Biryani",
    numberOfReviews: 200,
    averageRating: 4.9,
    description:
        "Aromatic basmati rice cooked with tender pieces of chicken and traditional spices.",
    restaurantName: "Indian Spice Emporium",
    price: 11.50,
    imageUrl: "chicken_biryani.jpg",
    itemImages: [
      ItemMedia(
          id: '123',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    itemVideos: const [],
    tags: const ["Rice", "Indian", "Spicy"],
    categoryId: "4",
    fasting: false,
    createdAt: DateTime(2023, 4, 1),
    updatedAt: DateTime(2023, 4, 6),
    ingredients: const [],
    categories: const Categories(id: "4", name: "Indian", menuId: "4"),
    minutes: 30,
    isOpen: true,
    isFavorite: false,
    distance: "5 km",
    walkingTime: "1 hour",
    ridingTime: "15 mins",
  ),
  ItemModel(
    itemId: "5",
    itemName: "Caesar Salad",
    numberOfReviews: 75,
    averageRating: 4.3,
    description:
        "Crisp romaine lettuce, Parmesan cheese, and croutons, dressed with lemon-anchovy dressing.",
    restaurantName: "Green Leaf Bistro",
    price: 7.99,
    imageUrl: "caesar_salad.jpg",
    itemImages: [
      ItemMedia(
          id: '123',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    itemVideos: const [],
    tags: const ["Salad", "Healthy", "Vegetarian"],
    categoryId: "5",
    fasting: true,
    createdAt: DateTime(2023, 5, 20),
    updatedAt: DateTime(2023, 5, 25),
    ingredients: const [],
    categories: const Categories(id: "5", name: "Salads", menuId: "5"),
    minutes: 10,
    isOpen: true,
    isFavorite: true,
    distance: "1 km",
    walkingTime: "15 mins",
    ridingTime: "5 mins",
  ),
];

var itemsSortedByRating = sortByRating(dummyItems);
var itemsSortedByPrice = sortByPrice(dummyItems);
var itemsSortedByDistance = sortByDistance(dummyItems);
