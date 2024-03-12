import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/total_price.dart';

void main() {
  group('test totalPrice', () {
    test('should create instance of totalPrice with required fields', () {
      final TotalPrice totalPrice = TotalPrice(totalItems: 10, totalPrice: 200);
      expect(totalPrice.totalItems, 10);
      expect(totalPrice.totalPrice, 200);
    });

    test('should check value equality using Equatable', () {
      final TotalPrice totalPrice1 = TotalPrice(totalItems: 2, totalPrice: 100);
      final TotalPrice totalPrice2 = TotalPrice(totalItems: 2, totalPrice: 100);

      expect(totalPrice1, equals(totalPrice2));
    });
  });
}
