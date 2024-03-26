import 'package:user_mobile_app/features/prescriptions/data/model/permission_prescription.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';

abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionLoaded extends PrescriptionState {
  final List<Prescription> prescriptions;

  PrescriptionLoaded({required this.prescriptions});
}

class PrescriptionError extends PrescriptionState {
  final String message;

  PrescriptionError({required this.message});
}

class UploadingPrescription extends PrescriptionState {}

class PrescriptionUploaded extends PrescriptionState {
  final Prescription prescription;

  PrescriptionUploaded({required this.prescription});
}

class PrescriptionUploadError extends PrescriptionState {
  final String message;

  PrescriptionUploadError({required this.message});
}

class FetchingRequest extends PrescriptionState {}

class RequestFetched extends PrescriptionState {
  final List<PrescriptionPermission> permission;

  RequestFetched({required this.permission});
}

class RequestFetchError extends PrescriptionState {
  final String message;

  RequestFetchError({required this.message});
}

class UpdatingPermissionStatus extends PrescriptionState {}

class PermissionStatusUpdated extends PrescriptionState {
  final bool status;
  final String id;
  final String message;

  PermissionStatusUpdated({
    required this.status,
    required this.id,
    required this.message,
  });
}

class PermissionStatusUpdateError extends PrescriptionState {
  final String message;

  PermissionStatusUpdateError({required this.message});
}

class RevokingPermission extends PrescriptionState {}

class PermissionRevoked extends PrescriptionState {}

class PermissionRevokeError extends PrescriptionState {
  final String message;

  PermissionRevokeError({required this.message});
}

class TokenExpired extends PrescriptionState {}
