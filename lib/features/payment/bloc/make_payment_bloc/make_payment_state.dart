// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class MakePaymentState {}

class MakePaymentInitial extends MakePaymentState {}

class MakePaymentLoading extends MakePaymentState {}

class InitiatePaymentSuccess extends MakePaymentState {
  final String khaltiToken;

  InitiatePaymentSuccess({
    required this.khaltiToken,
  });
}

class InitiatePaymentFailure extends MakePaymentState {
  final String message;

  InitiatePaymentFailure({
    required this.message,
  });
}

class TokenExpired extends MakePaymentState {}

class ConfirmPaymentSuccess extends MakePaymentState {}

class ConfirmPaymentFailure extends MakePaymentState {
  final String message;

  ConfirmPaymentFailure({
    required this.message,
  });
}
