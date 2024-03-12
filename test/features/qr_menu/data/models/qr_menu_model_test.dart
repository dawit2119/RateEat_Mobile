import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('QRMenuModel', () {
    test('should create a QRMenuModel from a valid map', () {
      // Given
      final Map<String, dynamic> data = {
        'count': 1,
        'background_color': '#FFFFFF',
        'item_background_color': '#F0F0F0',
        'restaurant': {
          'id': 'restaurant_id',
          'name': 'Restaurant Name',
          'restaurantImage': {
            'url': 'https://example.com/image.jpg',
          },
        },
        'data': {
          'category1': {
            'id': 'cat1',
            'name': 'Category 1',
            'items': [
              {
                'category_id': 'cat1',
                'fasting': false,
                'name': 'Item 1',
                'average_rating': 4.5,
                'price': 10,
                'number_of_reviews': 5,
                'id': 'item_id_1',
                'item_images': [
                  {'url': 'https://example.com/item1.jpg'},
                ],
              },
            ],
          },
        },
      };

      // When
      final menu = QRMenuModel.fromMap(data);

      // Then
      expect(menu.totalCategories, 1);
      expect(menu.restaurantName, 'Restaurant Name');
      expect(menu.restaurantId, 'restaurant_id');
      expect(menu.restaurantImageUrl, 'https://example.com/image.jpg');
      expect(menu.backgroundColor, '#FFFFFF');
      expect(menu.itemBackgroundColor, '#F0F0F0');
      expect(menu.categories.length, 1);
      expect(menu.items.isNotEmpty, true);
      expect(menu.items.keys.first.name, 'Category 1');
      expect(menu.items.values.first.length, 1);
      expect(menu.items.values.first.first.name, 'Item 1');
    });

    test('should throw an exception if data is null', () {
      // Given
      final data = <String, dynamic>{};

      // When & Then
      expect(
          () => QRMenuModel.fromMap(data),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('unable to parse data'))));
    });

    test('should create a QRMenuModel from single category map', () {
      // Given
      final data = {
        "success": true,
        "count": 8,
        "pagination": {},
        "totalPages": 1,
        "data": [
          {
            "id": "f176c6ce-34e3-4e2b-a094-0afa013831d6",
            "name": "Grilled Chicken Wrap",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 9,
            "average_rating": 4.11,
            "price": 649,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": false,
            "price_updated_at": "2023-10-15T12:10:44.895Z",
            "popularity_index": 739,
            "createdAt": "2023-10-15T12:10:44.895Z",
            "updatedAt": "2025-03-14T08:57:08.072Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "10631318-63b5-47c8-ba44-92d1212658ac",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792102088-medium.webp"
              },
              {
                "id": "bad6c51c-acec-4a82-ac0f-354609548fb7",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727783668420-medium.webp"
              },
              {
                "id": "8a675749-d3b3-4487-b28e-20c43d77e474",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792098393-medium.webp"
              },
              {
                "id": "44762be0-c447-43aa-9653-b4033f40df88",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727773559714-medium.webp"
              },
              {
                "id": "55246e64-700f-4dcb-8f25-4e44caee75bb",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727773062931-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {"id": "6f1bb263-c1f8-474f-93d5-a0fe335d3711", "name": "Aioli"},
              {"id": "6f34b46a-f86d-4072-bfa5-0af1b41ec4e1", "name": "Pesto"},
              {
                "id": "3fb47bdf-1b06-4d4d-9c46-65d8b47f2df7",
                "name": "Grilled chicken breast"
              }
            ],
            "item_tags": [
              {"id": "be11b6a3-4578-4420-bbaa-706af7fc5dc7", "name": "Wrap"},
              {"id": "af8bad57-fa08-4a69-8eb2-ccc84d4dfc07", "name": "Chicken"},
              {"id": "a7b88ee7-df30-462e-ad62-6fefb0417064", "name": "Grilled"}
            ]
          },
          {
            "id": "2283b5d3-2c76-4a1a-8383-d739d1921439",
            "name": "Grilled Beef Fillet",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 1,
            "average_rating": 3,
            "price": 419,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": false,
            "price_updated_at": "2023-10-15T12:10:47.213Z",
            "popularity_index": 17,
            "createdAt": "2023-10-15T12:10:47.213Z",
            "updatedAt": "2025-03-13T10:34:00.627Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "ee204855-a724-45d0-9e49-2cce3c238cde",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792104684-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {"id": "576c57f0-74db-4e27-b255-14f2960328f0", "name": "Aioli"},
              {"id": "4ca09c72-0914-47b9-a992-59d3a27ffcaf", "name": "Pesto"},
              {
                "id": "b933fd48-bb2c-436a-a1fc-4fe1bfcc5f44",
                "name": "Grilled beef"
              }
            ],
            "item_tags": [
              {"id": "207c5ec4-d39a-4130-9494-5864183d8096", "name": "Wrap"},
              {"id": "1c17208a-b5a2-4cea-bf97-42382f03d7e2", "name": "Beef"},
              {"id": "8ce8804f-31ff-4f16-ac19-e95e20c48cdf", "name": "Grilled"}
            ]
          },
          {
            "id": "ca41331c-dc21-4b32-a601-6808031dcaef",
            "name": "Chicken Wrap With Mozzarella Cheese",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 0,
            "average_rating": 0,
            "price": 449,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:10:49.547Z",
            "popularity_index": 12,
            "createdAt": "2023-10-15T12:10:49.547Z",
            "updatedAt": "2025-03-13T14:27:17.919Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [],
            "item_videos": [],
            "ingredients": [
              {"id": "cf000f71-4387-4e0d-9bd4-e47e9a24951d", "name": "Pesto"},
              {
                "id": "d0f8de38-e8b8-45d7-a536-715f154c3683",
                "name": "Cucumber"
              },
              {"id": "9f8a3880-17a4-4a5d-a866-4f128ee7d75d", "name": "Onion"},
              {
                "id": "05a67676-bc46-453f-9869-c7c74744b4e8",
                "name": "Mozzarella cheese"
              },
              {"id": "349c71ca-7874-43f6-8e73-ad596548344e", "name": "Tomato"},
              {
                "id": "382158a8-6fa3-4170-bc3a-cf81009f37ad",
                "name": "Chicken breast"
              }
            ],
            "item_tags": [
              {"id": "502ad492-51be-4c60-821d-c19279c8c41b", "name": "Wrap"},
              {"id": "e8b39455-7957-4129-87ec-0cde1b623167", "name": "Chicken"},
              {"id": "570c4c1d-6188-4d8e-9a59-c34371ddd533", "name": "Cheese"}
            ]
          },
          {
            "id": "6bc343e3-b86c-4984-92f3-2ff0c1a84ff0",
            "name": "Chicken Wrap With Grilled Vegetable",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 3,
            "average_rating": 4.33,
            "price": 369,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": true,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:10:52.923Z",
            "popularity_index": 36,
            "createdAt": "2023-10-15T12:10:52.923Z",
            "updatedAt": "2025-03-13T15:30:18.797Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "a6c6e36b-d066-48d5-bf4f-983100a5a677",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727782960526-medium.webp"
              },
              {
                "id": "de2e2498-8a0d-49bc-b5a7-2e9d098d34e1",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727773062624-medium.webp"
              },
              {
                "id": "c0986b6d-fb32-4f83-b453-35bbb9ba705d",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727782693418-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {"id": "711c1137-d2d0-4cb7-a3bf-c086f9b57b90", "name": "Aioli"},
              {"id": "85180051-a7e5-48f5-8d45-dc59d75d3da1", "name": "Pesto"},
              {
                "id": "36384b12-5b5d-418d-9ca5-870aeb3f3c05",
                "name": "Grilled chicken breast"
              }
            ],
            "item_tags": [
              {"id": "507b07dc-2a83-4327-af0d-84fb59e6aafc", "name": "Wrap"},
              {"id": "d00b1152-2cca-4f84-9d6b-832a12555df4", "name": "Chicken"},
              {"id": "7af66e7e-cd9e-4056-ac13-750fd4d355c5", "name": "Grilled"}
            ]
          },
          {
            "id": "94ae6755-8410-4712-b8dc-2f462005ccc4",
            "name": "Avocado Barley, Chicken Wrap (spicy)",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 1,
            "average_rating": 5,
            "price": 339,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:10:55.226Z",
            "popularity_index": 59,
            "createdAt": "2023-10-15T12:10:55.226Z",
            "updatedAt": "2025-03-14T08:16:48.020Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [],
            "item_videos": [],
            "ingredients": [
              {
                "id": "5cffca4e-ad31-4db2-a4ee-cc9a5a554dc6",
                "name": "Chili pepper"
              },
              {"id": "5efb0e87-4563-46ff-96a1-64ebbbd5331e", "name": "Chicken"},
              {"id": "42148fd2-a186-491d-a861-8963c37f7510", "name": "Tomato"},
              {
                "id": "160c98bd-a12a-4c61-8c03-f68ba415b800",
                "name": "Cucumber"
              },
              {"id": "c4e25830-3be6-43e7-befd-944781826ce2", "name": "Barley"},
              {"id": "6c3b5ced-fb3e-4292-90f2-708634ba2206", "name": "Avocado"}
            ],
            "item_tags": [
              {"id": "680e5e35-a08d-489a-ac83-bdf9fbfe334c", "name": "Wrap"},
              {"id": "b4a4f994-c889-4018-931d-860c4e705bf4", "name": "Avocado"},
              {"id": "23f69236-af9b-4ba7-8ef8-86bafc5fa9ae", "name": "Barley"},
              {"id": "4950e7fe-9742-48eb-be36-e294acb270e0", "name": "Chicken"},
              {"id": "34ee2227-5d2b-4168-8a45-ff0a404c0795", "name": "Spicy"}
            ]
          },
          {
            "id": "fb50f0d3-c99e-4489-a4ce-ba1554186bd3",
            "name": "Falafel Wrap",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 2,
            "average_rating": 4.5,
            "price": 349,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": true,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:10:59.370Z",
            "popularity_index": 39,
            "createdAt": "2023-10-15T12:10:59.370Z",
            "updatedAt": "2025-03-13T10:36:36.787Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "4e81f52d-ac92-4dda-8453-4b073c495939",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792102886-medium.webp"
              },
              {
                "id": "8162b43b-323f-47a5-9268-682044dcf6a9",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727782957921-medium.webp"
              },
              {
                "id": "b2415dfa-1404-4f86-b702-3f82a5fd7267",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727782693433-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {
                "id": "9c847f58-497a-4665-b595-d4cddfaac8e5",
                "name": "Tahini sauce"
              },
              {"id": "38c94645-0cd1-423f-af52-12bdcb0dd334", "name": "Tomato"},
              {
                "id": "6d3b34e6-70a4-44dc-aff8-609d095e499e",
                "name": "Cucumber"
              },
              {"id": "f438de66-7053-41b7-99a0-88fc26df815b", "name": "Falafel"}
            ],
            "item_tags": [
              {"id": "e86a02ad-db86-4cef-9429-b84fd8133cb8", "name": "Wrap"},
              {"id": "1298da6c-0121-44b1-a580-4d8e61c90222", "name": "Falafel"}
            ]
          },
          {
            "id": "7c476ed1-6226-4832-be1b-b01e39f4af6e",
            "name": "Egg & Spinach Wrap",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 0,
            "average_rating": 0,
            "price": 339,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:11:01.737Z",
            "popularity_index": 1,
            "createdAt": "2023-10-15T12:11:01.737Z",
            "updatedAt": "2024-01-22T14:40:28.886Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "f6567f4b-7a07-4487-ba7d-ab8dccb0b0db",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792100400-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {
                "id": "b1c80ff7-f3c5-4770-a3c1-612cd0324c85",
                "name": "Chili pepper"
              },
              {"id": "7da7b87c-2709-4769-acd4-d6c7d8b6c588", "name": "Spinach"},
              {"id": "3cc92ef4-d56d-4a5e-8a0b-15826de787b8", "name": "Egg"}
            ],
            "item_tags": [
              {"id": "68d7ea2d-5c32-4a2b-acc4-3346aa417dfa", "name": "Wrap"},
              {"id": "2ebbd3fd-5c3d-42cb-b1a0-ffc44d892d4a", "name": "Egg"},
              {"id": "f5d8ed92-7eff-446f-90c6-9ee2466483af", "name": "Spinach"}
            ]
          },
          {
            "id": "8e971eb6-1ca6-43dd-a7cc-6ee31a32008b",
            "name": "Chicken Mortadella Sandwich",
            "description": "",
            "is_approved": true,
            "number_of_reviews": 1,
            "average_rating": 4,
            "price": 339,
            "category_id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
            "fasting": false,
            "is_available_for_order": true,
            "price_updated_at": "2023-10-15T12:11:04.434Z",
            "popularity_index": 6,
            "createdAt": "2023-10-15T12:11:04.434Z",
            "updatedAt": "2024-01-23T08:53:54.641Z",
            "categories": {
              "id": "1c7ffa36-e9db-4875-9716-37d2448adbc0",
              "url": "",
              "name": "Wraps & Sandwiches",
              "menu_id": "3abfa8d9-8862-45b2-b50f-fb3a572bd536"
            },
            "item_images": [
              {
                "id": "38aac2b4-8432-41de-9712-07117d4d4a90",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727782958926-medium.webp"
              },
              {
                "id": "4d8d27b4-212e-40bb-a468-d0865e93428a",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792105817-medium.webp"
              },
              {
                "id": "d125469e-910f-4371-93fd-2cfe0f1c2e9d",
                "url":
                    "https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1727792100996-medium.webp"
              }
            ],
            "item_videos": [],
            "ingredients": [
              {"id": "a87b7aaa-6ca5-4554-9ef0-dfbce7d40066", "name": "Pesto"},
              {"id": "667bcf80-d5b1-4c90-9bf7-bbcc2482af98", "name": "Tomato"},
              {"id": "2d91b042-5603-4eb8-b12e-171184078e9b", "name": "Cheese"},
              {
                "id": "ddf2a11f-2ff5-4a34-a810-33c1d377dbff",
                "name": "Chicken mortadella"
              }
            ],
            "item_tags": [
              {
                "id": "51868733-1aca-4c9b-9677-36d3d669bd49",
                "name": "Sandwich"
              },
              {"id": "e56c1454-089a-4659-8ec8-e6fe1db24a75", "name": "Chicken"},
              {"id": "9c482a89-556c-4e18-b392-d626415fd454", "name": "Cheese"}
            ]
          }
        ],
        "restaurant": {
          "id": "restaurant_id",
          "name": "restaurant_name",
          "restaurantImage": {
            "id": "e10dc9bc-33cb-4939-b7e3-1a9863b76f6b",
            "url":
                "https://storage.googleapis.com/rateeat_bucket/RateEat/RestaurantImages/1707826328415.jpg",
            "is_leading": true,
            "high_quality_url":
                "https://storage.googleapis.com/rateeat_bucket/RateEat/RestaurantImagesUpdated/1727332665884-high.webp",
            "medium_quality_url":
                "https://storage.googleapis.com/rateeat_bucket/RateEat/RestaurantImagesUpdated/1727332665884-medium.webp",
            "low_quality_url":
                "https://storage.googleapis.com/rateeat_bucket/RateEat/RestaurantImagesUpdated/1727332665884-low.webp",
            "restaurant_id": "fddb3dbb-e59f-4235-a1c4-56945974d30c",
            "createdAt": "2024-02-13T12:12:09.244Z",
            "updatedAt": "2024-09-26T06:38:35.903Z"
          }
        },
        "style": null,
        "priceRanges": {
          "0-200": {"min": 0, "max": 200, "count": 0},
          "200-500": {"min": 200, "max": 500, "count": 7},
          "500-1000": {"min": 500, "max": 1000, "count": 1},
          "1000-2000": {"min": 1000, "max": 2000, "count": 0},
          "2000-above": {"min": 2000, "max": 9007199254740991, "count": 0}
        }
      };

      final category = QRCategoryModel.fromMap({
        'id': 'cat1',
        'name': 'Wraps & Sandwiches',
      });

      // When
      final menu = QRMenuModel.fromSingleCategoryMap(data, category);

      // Then
      expect(menu.restaurantId, 'restaurant_id');
      expect(menu.restaurantName, 'restaurant_name');
      expect(menu.restaurantImageUrl,
          "https://storage.googleapis.com/rateeat_bucket/RateEat/RestaurantImages/1707826328415.jpg");
      expect(menu.totalCategories, 8);
      expect(menu.items.keys.first.name, 'Wraps & Sandwiches');
      expect(menu.items[category]?.first.name, 'Grilled Chicken Wrap');
    });
  });
}
