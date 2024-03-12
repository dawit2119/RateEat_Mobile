import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/popular_search_item.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';

void main() {
  const popularSearchItem = PopularSearchModel(
    restaurants: ['restaurant'],
    items: ['item'],
  );

  group('popular search item', () {
    test('should be a subclass of PopularSearch', () async {
      // assert
      expect(popularSearchItem, isA<PopularSearchItems>());
    });

    group('from json', () {
      test('should return a valid model from json', () async {
        //act
        final result = PopularSearchModel.fromJson(const {
          'restaurant': ['restaurant'],
          'item': ['item']
        });
        // assert
        expect(result, isA<PopularSearchModel>());
      });
    });

    group('to json', () {
      test('should return a json map containing the proper data', () async {
        //assert
        final expectedMap = {
          "restaurants": ['restaurant'],
          "items": ['item'],
        };
        //act
        final result = popularSearchItem.toJson();
        //assert
        expect(result, expectedMap);
      });
    });
  });
}
