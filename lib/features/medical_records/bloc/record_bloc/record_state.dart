// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/data/model/record_request.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<MedicalRecord> records;

  RecordLoaded({required this.records});
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

class UpdatingRecord extends RecordState {}

class RecordUpdated extends RecordState {
  final MedicalRecord record;

  RecordUpdated({required this.record});
}

class RecordUpdateError extends RecordState {
  final String message;

  RecordUpdateError({required this.message});
}

class FetchingRequest extends RecordState {}

class RequestFetched extends RecordState {
  final List<RecordRequest> requests;

  RequestFetched({required this.requests});
}

class RequestError extends RecordState {
  final String message;

  RequestError({required this.message});
}

class UpdatingRequestStatus extends RecordState {}

class RequestStatusUpdated extends RecordState {
  final String id;
  final bool value;
  final String message;

  RequestStatusUpdated({
    required this.id,
    required this.value,
    required this.message,
  });
}

class RequestStatusError extends RecordState {
  final String message;

  RequestStatusError({required this.message});
}

class RevokingPermission extends RecordState {}

class PermissionRevoked extends RecordState {
}

class PermissionRevokeError extends RecordState {
  final String message;

  PermissionRevokeError({required this.message});
}