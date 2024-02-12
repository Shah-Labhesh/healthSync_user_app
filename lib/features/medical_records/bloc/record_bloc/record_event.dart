abstract class RecordEvent {}

class FetchRecords extends RecordEvent {
  final String sort;

  FetchRecords({required this.sort});
}

class UploadRecordEvent extends RecordEvent {
  Map<String, dynamic> record;
  UploadRecordEvent({required this.record});
}

class FetchPatientList extends RecordEvent {}

class UploadRecordByDoctor extends RecordEvent {
  final String patientId;
  Map<String, dynamic> record;
  UploadRecordByDoctor({required this.record, required this.patientId});
}

class FetchDoctorList extends RecordEvent {}

class ShareRecord extends RecordEvent {
  final String recordId;
  final String doctorId;
  ShareRecord({required this.recordId, required this.doctorId});
}

class RevokeSharedRecord extends RecordEvent {
  final String recordId;
  RevokeSharedRecord({required this.recordId});
}
