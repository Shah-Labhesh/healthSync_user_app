import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<MedicalRecord> records;

  RecordLoaded({required this.records});
}

class ShareRecordLoaded extends RecordState {
  final List<ShareMedicalRecord> records;

  ShareRecordLoaded({required this.records});
}

class RecordError extends RecordState {
  final String message;

  RecordError({required this.message});
}

class TokenExpired extends RecordState {}

class UploadRecordLoading extends RecordState {}

class UploadRecordSuccess extends RecordState {
  final MedicalRecord record;

  UploadRecordSuccess({required this.record});
}

class UploadRecordError extends RecordState {
  final String message;

  UploadRecordError({required this.message});
}

class PatientListLoading extends RecordState {}

class PatientListLoaded extends RecordState {
  final List<User> patients;

  PatientListLoaded({required this.patients});
}

class PatientListError extends RecordState {
  final String message;

  PatientListError({required this.message});
}


class FetchingDoctorList extends RecordState {}

class DoctorListFetched extends RecordState {
  final List<User> doctors;

  DoctorListFetched({required this.doctors});
}

class DoctorListError extends RecordState {
  final String message;

  DoctorListError({required this.message});
}

class SharingRecord extends RecordState {}

class RecordShared extends RecordState {
  final String message;

  RecordShared({required this.message});
}

class RecordShareError extends RecordState {
  final String message;

  RecordShareError({required this.message});
}

class RevokingRecord extends RecordState {}

class RecordRevokedSuccess extends RecordState {
  final String id;

  RecordRevokedSuccess({required this.id});
}

class RecordRevokedError extends RecordState {
  final String message;

  RecordRevokedError({required this.message});
}

class UpdatingRecord extends RecordState {}

class RecordUpdated extends RecordState {
  final MedicalRecord record;

  RecordUpdated({required this.record});
}

class RecordUpdateError extends RecordState {
  final String message;

  RecordUpdateError({required this.message});
}