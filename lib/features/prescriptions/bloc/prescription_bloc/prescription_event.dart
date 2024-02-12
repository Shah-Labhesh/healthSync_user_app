abstract class PrescriptionEvent {}

class FetchPrescriptionsEvent extends PrescriptionEvent {}

class FetchPatientsEvent extends PrescriptionEvent {}

class UploadPrescriptionEvent extends PrescriptionEvent {
  final Map<String, dynamic> prescription;
  UploadPrescriptionEvent({required this.prescription});
}
