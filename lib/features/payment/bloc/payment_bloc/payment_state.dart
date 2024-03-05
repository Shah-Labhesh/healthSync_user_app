import 'package:user_mobile_app/features/payment/data/model/payment.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final List<Payment> payments;

  PaymentSuccess({required this.payments});
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure({required this.message});
}

class TokenExpired extends PaymentState {}

