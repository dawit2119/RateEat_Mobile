import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history_model.dart';

void main() {
  final historyModel = HistoryModel(
    id: '1',
    title: 'title',
  );

  group('history model', () {
    test('should be a subclass of History', () async {
      // assert
      expect(historyModel, isA<History>());
    });

    group('from json', () {
      test('should return a valid model from json', () async {
        //act
        final result = HistoryModel.fromJson({"id": "1", "title": "title"});
        // assert
        expect(result, isA<HistoryModel>());
      });
    });

    group('to json', () {
      test('should return a json map containing the proper data', () async {
        //assert
        final expectedMap = {
          "id": "1",
          "title": "title",
        };
        //act
        final result = historyModel.toJson();
        //assert
        expect(result, expectedMap);
      });
    });
  });
}
