import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';

abstract class PatientViewState {}

class PatientViewInitial extends PatientViewState {}

class RecordsLoading extends PatientViewState {}

class RecordsLoaded extends PatientViewState {
  final List<MedicalRecord> medicalRecords;

  RecordsLoaded({
    required this.medicalRecords,
  });
}

class RecordsError extends PatientViewState {
  final String message;

  RecordsError({required this.message});
}

class NoPremissionForRecords extends PatientViewState {
  final String message;

  NoPremissionForRecords({required this.message});
}

class PrescriptionLoading extends PatientViewState {}

class PrescriptionLoaded extends PatientViewState {
  final List<Prescription> prescriptions;

  PrescriptionLoaded({
    required this.prescriptions,
  });
}

class NoPremissionForPrescription extends PatientViewState {
  final String message;

  NoPremissionForPrescription({required this.message});
}

class PrescriptionError extends PatientViewState {
  final String message;

  PrescriptionError({required this.message});
}

class RequestingPrescriptionPermission extends PatientViewState {}

class PermissionRequested extends PatientViewState {
  final String message;

  PermissionRequested({required this.message});
}

class PermissionRequestError extends PatientViewState {
  final String message;

  PermissionRequestError({required this.message});
}

class RequestingRecordPermission extends PatientViewState {}

class RecordPermissionRequested extends PatientViewState {
  final String message;

  RecordPermissionRequested({required this.message});
}

class RecordPermissionRequestError extends PatientViewState {
  final String message;

  RecordPermissionRequestError({required this.message});
}

class TokenExpired extends PatientViewState {}
