abstract class ContactEvent {}

class ContactFormSubmitted extends ContactEvent {
  final String email;
  final String message;

  ContactFormSubmitted({required this.email, required this.message});
}