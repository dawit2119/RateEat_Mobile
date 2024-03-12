import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

class PaymentRequestModel extends PaymentRequestEntity {
  const PaymentRequestModel({
    required super.orderId,
    required super.firstName,
    required super.lastName,
    super.email,
    super.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
