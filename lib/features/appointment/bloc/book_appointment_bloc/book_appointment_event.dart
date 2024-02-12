abstract class BookAppointmentEvent {}

class FetchSlots extends BookAppointmentEvent {
  final String doctorId;

  FetchSlots({required this.doctorId});
}

class BookAppointment extends BookAppointmentEvent {
  final Map<String, dynamic> appointmentData;

  BookAppointment({required this.appointmentData});
}