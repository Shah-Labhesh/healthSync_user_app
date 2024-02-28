abstract class MakePaymentEvent {}

class InitiatePayment extends MakePaymentEvent {
  final Map<String, dynamic> data;

  InitiatePayment({
    required this.data,
  });
}

class ConfirmPayment extends MakePaymentEvent {
  final Map<String, dynamic> data;

  ConfirmPayment({
    required this.data,
  });
}
