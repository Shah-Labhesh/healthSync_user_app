abstract class PatientViewEvent {}

class FetchMedicalRecords extends PatientViewEvent {
  final String patientId;

  FetchMedicalRecords({required this.patientId});
}


class FetchPrescriptions extends PatientViewEvent {
  final String patientId;

  FetchPrescriptions({required this.patientId});
}

class RequestPermissonForRecords extends PatientViewEvent {
  final String patientId;

  RequestPermissonForRecords({required this.patientId});
}

class RequestPermissonForPrescription extends PatientViewEvent {
  final String patientId;

  RequestPermissonForPrescription({required this.patientId});
}
