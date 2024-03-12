import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'dart:convert';
import '../../../../helper/json_reader.dart';

void main() {
  final itemModel = ItemModel(
    itemId: '1',
    itemName: '',
    numberOfReviews: 0,
    description: "",
    averageRating: 0.0,
    price: 134,
    imageUrl:
        "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
    itemImages: const [],
    itemVideos: const [],
    restaurantName: '',
    tags: const [''],
    categoryId: "",
    fasting: false,
    createdAt: DateTime.parse('2022-01-01 00:00:00.000Z'),
    updatedAt: DateTime.parse('2022-01-01 00:00:00.000Z'),
    ingredients: const [],
    categories: null,
    minutes: 0,
    isOpen: false,
    isFavorite: false,
    distance: "0.0",
    walkingTime: "",
    ridingTime: "",
  );

  group('item model', () {
    test('should be a subclass of ItemEntity', () async {
      // assert
      expect(itemModel, isA<Item>());
    });

    group('from json', () {
      test('should return a valid model from json', () async {
        //arrange
        final jsonMap =
            json.decode((readJson('item_detail/item_detail_response.json')))
                as Map<String, dynamic>;
        //act

        final result = ItemModel.fromJson(jsonMap);
        // assert
        expect(result, isA<ItemModel>());
      });
    });

    group('to json', () {
      test('should return a json map containing the proper data', () async {
        //assert
        final expectedMap = {
          "itemId": "1",
          "itemName": "",
          "numberOfReviews": 0,
          "restaurantName": "",
          "description": "",
          "averageRating": 0.0,
          "price": 134,
          "imageUrl":
              "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
          "item_images": [],
          "itemVideos": [],
          "tags": [''],
          "categoryId": "",
          "fasting": false,
          "createdAt": "2022-01-01T00:00:00.000Z",
          "updatedAt": "2022-01-01T00:00:00.000Z",
          "ingredients": [],
          "categories": null,
          "minutes": 0,
          "isOpen": false,
          "isFavorite": false,
          "distance": "0.0",
          "walkingTime": "",
          "ridingTime": "",
        };

        //act
        final result = itemModel.toJson();

        // assert
        expect(result['id'], expectedMap['itemId']);
        expect(result['name'], expectedMap['itemName']);
        expect(result['number_of_reviews'], expectedMap['numberOfReviews']);
        expect(result['description'], expectedMap['description']);
        expect(result['average_rating'], expectedMap['averageRating']);
        expect(result['price'], expectedMap['price']);
        expect(result['image_url'], expectedMap['imageUrl']);
        expect(result['item_images'], expectedMap['item_images']);
        expect(result['item_videos'], expectedMap['itemVideos']);
        expect(result['restaurant_name'], expectedMap['restaurantName']);
        expect(result['item_tags'], expectedMap['tags']);
        expect(result['category_id'], expectedMap['categoryId']);
        expect(result['fasting'], expectedMap['fasting']);
        expect(result['createdAt'], expectedMap['createdAt']);
        expect(result['updatedAt'], expectedMap['updatedAt']);
        expect(result['ingredients'], expectedMap['ingredients']);
        expect(result['categories'], expectedMap['categories']);
        expect(result['minutes'], expectedMap['minutes']);
        expect(result['isOpen'], expectedMap['isOpen']);
        expect(result['isFavorite'], expectedMap['isFavorite']);
        expect(result['distance'], expectedMap['distance']);
        expect(result['walking_time'], expectedMap['walkingTime']);
        expect(result['riding_time'], expectedMap['ridingTime']);
      });
    });
  });
}
