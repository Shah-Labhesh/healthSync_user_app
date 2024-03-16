abstract class MyAppointmentEvent {}

class FetchMyAppointmentEvent extends MyAppointmentEvent {}

class CancelAppointmentEvent extends MyAppointmentEvent {
  final String appointmentId;

  CancelAppointmentEvent({required this.appointmentId});
}
