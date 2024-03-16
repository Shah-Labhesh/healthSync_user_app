abstract class RecordEvent {}

class FetchRecords extends RecordEvent {}

class UploadRecordEvent extends RecordEvent {
  Map<String, dynamic> record;
  UploadRecordEvent({required this.record});
}

class UploadRecordByDoctor extends RecordEvent {
  final String patientId;
  Map<String, dynamic> record;
  UploadRecordByDoctor({required this.record, required this.patientId});
}

class UpdateRecord extends RecordEvent {
  final String recordId;
  final Map<String, dynamic> record;
  UpdateRecord({required this.recordId, required this.record});
}

class FetchAllRequest extends RecordEvent {}

class UpdateRequestStatus extends RecordEvent {
  final String requestId;
  final bool value;
  UpdateRequestStatus({required this.requestId, required this.value});
}
