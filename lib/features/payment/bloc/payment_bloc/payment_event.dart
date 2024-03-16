abstract class PaymentEvent {}

class GetMyPayments extends PaymentEvent {
  final String sort;

  GetMyPayments({required this.sort});
}


class UpdateKhalti extends PaymentEvent {
  final String khalti;

  UpdateKhalti({required this.khalti});

}