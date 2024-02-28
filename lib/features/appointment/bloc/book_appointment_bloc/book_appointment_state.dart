import 'package:user_mobile_app/features/slots/data/model/slot.dart';

abstract class BookAppointmentState {}

class BookAppointmentInitial extends BookAppointmentState {}

class BookAppointmentLoading extends BookAppointmentState {}

class BookAppointmentSuccess extends BookAppointmentState {
  final String appointmentId;

  BookAppointmentSuccess({required this.appointmentId});
}

class BookAppointmentFailure extends BookAppointmentState {
  final String message;

  BookAppointmentFailure({required this.message});
}

class FetchSlotsLoading extends BookAppointmentState {}

class FetchSlotsSuccess extends BookAppointmentState {
  final List<Slots> slots;

  FetchSlotsSuccess({required this.slots});
}

class FetchSlotsFailure extends BookAppointmentState {
  final String message;

  FetchSlotsFailure({required this.message});
}

class TokenExpired extends BookAppointmentState {}
