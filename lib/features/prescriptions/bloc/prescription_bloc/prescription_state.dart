import 'package:user_mobile_app/features/account/data/model/user.dart';
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

class PatientListLoading extends PrescriptionState {}

class PatientListLoaded extends PrescriptionState {
  final List<User> patients;

  PatientListLoaded({required this.patients});
}

class PatientListError extends PrescriptionState {
  final String message;

  PatientListError({required this.message});
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



class TokenExpired extends PrescriptionState {}