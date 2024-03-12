import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/data/models/payment_request_model.dart';

void main() {
  group('PaymentRequestModel', () {
    test('toJson should correctly convert PaymentRequestModel to map', () {
      // Arrange: Create an instance of PaymentRequestModel
      const paymentRequest = PaymentRequestModel(
        orderId: 'order123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
      );

      // Act: Convert model to JSON map
      final jsonMap = paymentRequest.toJson();

      // Assert: Verify each field is correctly mapped
      expect(jsonMap['orderId'], 'order123');
      expect(jsonMap['firstName'], 'John');
      expect(jsonMap['lastName'], 'Doe');
      expect(jsonMap['email'], 'john.doe@example.com');
      expect(jsonMap['phoneNumber'], '+1234567890');
    });

    test('PaymentRequestModel properties should hold the expected values', () {
      // Arrange & Act: Create an instance of PaymentRequestModel
      const paymentRequest = PaymentRequestModel(
        orderId: 'order456',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        phoneNumber: '+0987654321',
      );

      // Assert: Verify that the properties match the initialized values
      expect(paymentRequest.orderId, 'order456');
      expect(paymentRequest.firstName, 'Jane');
      expect(paymentRequest.lastName, 'Smith');
      expect(paymentRequest.email, 'jane.smith@example.com');
      expect(paymentRequest.phoneNumber, '+0987654321');
    });

    test('PaymentRequestModel toJson should handle nullable fields', () {
      // Arrange: Create an instance without optional fields
      const paymentRequest = PaymentRequestModel(
        orderId: 'order789',
        firstName: 'Alice',
        lastName: 'Brown',
      );

      // Act: Convert model to JSON map
      final jsonMap = paymentRequest.toJson();

      // Assert: Verify that optional fields are null in the JSON map
      expect(jsonMap['orderId'], 'order789');
      expect(jsonMap['firstName'], 'Alice');
      expect(jsonMap['lastName'], 'Brown');
      expect(jsonMap['email'], null);
      expect(jsonMap['phoneNumber'], null);
    });
  });
}
