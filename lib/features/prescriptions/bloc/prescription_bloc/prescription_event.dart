abstract class PrescriptionEvent {}

class FetchPrescriptionsEvent extends PrescriptionEvent {}

class FetchPatientsEvent extends PrescriptionEvent {}

class UploadPrescriptionEvent extends PrescriptionEvent {
  final Map<String, dynamic> prescription;
  UploadPrescriptionEvent({required this.prescription});
}

class FetchPermissionsEvent extends PrescriptionEvent {}

class UpdatePermissionStatus extends PrescriptionEvent {
  final String permissionId;
  final bool status;
  UpdatePermissionStatus({required this.permissionId, required this.status});
}