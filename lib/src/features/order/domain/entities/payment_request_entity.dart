import 'package:equatable/equatable.dart';

class PaymentRequestEntity extends Equatable {
  final String orderId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;

  const PaymentRequestEntity({
    required this.orderId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        orderId,
        firstName,
        lastName,
        email,
        phoneNumber,
      ];
}
