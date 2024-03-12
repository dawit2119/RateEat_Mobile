import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/payment_request_entity.dart';

void main() {
  group('test payment request entity', () {
    test('should create instance with required fields', () {
      final PaymentRequestEntity paymentRequestEntity = PaymentRequestEntity(
          orderId: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'johndoe@gmail.com');

      expect(paymentRequestEntity.firstName, 'John');
      expect(paymentRequestEntity.lastName, 'Doe');
      expect(paymentRequestEntity.email, 'johndoe@gmail.com');
    });

    test('should check value equality using Equatable ', () {
      final paymentRequestEntity1 = PaymentRequestEntity(
          orderId: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'johndoe@gmail.com');

      final paymentRequestEntity2 = PaymentRequestEntity(
          orderId: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'johndoe@gmail.com');

      expect(paymentRequestEntity1, equals(paymentRequestEntity2));
    });
  });
}
