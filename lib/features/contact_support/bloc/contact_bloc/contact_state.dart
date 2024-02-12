abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactFailed extends ContactState {
  final String message;

  ContactFailed({required this.message});
}

class ContactSuccess extends ContactState {
  final String message;

  ContactSuccess({required this.message});
}

class TokenExpired extends ContactState {}
