import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';

void main() {
  group('FavoriteEvent', () {
    group('AddToFavorite', () {
      test('supports value comparison', () {
        const event1 = AddToFavorite(itemId: '123', restaurantId: '456');
        const event2 = AddToFavorite(itemId: '123', restaurantId: '456');
        const event3 = AddToFavorite(itemId: '789', restaurantId: '456');

        expect(event1, event2);
        expect(event1, isNot(event3));
      });

      test('props are correct', () {
        const event = AddToFavorite(itemId: '123', restaurantId: '456');
        expect(event.props, ['123', '456']);
      });
    });

    group('RemoveFromFavorite', () {
      test('supports value comparison', () {
        const event1 = RemoveFromFavorite(itemId: '123', restaurantId: '456');
        const event2 = RemoveFromFavorite(itemId: '123', restaurantId: '456');
        const event3 = RemoveFromFavorite(itemId: '789', restaurantId: '456');

        expect(event1, event2);
        expect(event1, isNot(event3));
      });

      test('props are correct', () {
        const event = RemoveFromFavorite(itemId: '123', restaurantId: '456');
        expect(event.props, ['123', '456']);
      });
    });

    group('ResetFavorite', () {
      test('supports value comparison', () {
        final event1 = ResetFavorite();
        final event2 = ResetFavorite();

        expect(event1, event2);
      });

      test('props are correct', () {
        final event = ResetFavorite();
        expect(event.props, []);
      });
    });
  });
}
