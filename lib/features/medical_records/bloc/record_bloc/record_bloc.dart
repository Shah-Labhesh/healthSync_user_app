import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/data/model/record_request.dart';
import 'package:user_mobile_app/features/medical_records/data/repo/record_repo.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(RecordInitial()) {
    on<FetchRecords>((event, emit) => _getrecords(event, emit));
    on<UploadRecordEvent>((event, emit) => _uploadRecord(event, emit));
    on<UploadRecordByDoctor>(
        (event, emit) => _uploadRecordByDoctor(event, emit));
    on<UpdateRecord>((event, emit) => _updateRecord(event, emit));
    on<FetchAllRequest>((event, emit) => _getRequests(event, emit));
    on<UpdateRequestStatus>((event, emit) => _updateRequest(event, emit));
    on<RevokePermission>((event, emit) => _revokePermission(event, emit));
  }

  void _getrecords(FetchRecords event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final response = await RecordRepo().getRecords();
      if (response.statusCode == 200) {
        emit(RecordLoaded(
            records: (response.data as List<dynamic>)
                .map((e) => MedicalRecord.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(RecordError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RecordError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _uploadRecord(UploadRecordEvent event, Emitter<RecordState> emit) async {
    emit(UploadRecordLoading());
    try {
      final response = await RecordRepo().uploadRecord(event.record);
      if (response.statusCode == 201) {
        emit(UploadRecordSuccess(record: MedicalRecord.fromMap(response.data)));
      } else {
        emit(UploadRecordError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UploadRecordError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UploadRecordError(message: e.response?.data["message"][0]));
            } else {
              emit(UploadRecordError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UploadRecordError(message: e.response?.data["message"][0]));
            } else {
              emit(UploadRecordError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UploadRecordError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UploadRecordError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _uploadRecordByDoctor(
      UploadRecordByDoctor event, Emitter<RecordState> emit) async {
    emit(UploadRecordLoading());
    try {
      final response = await RecordRepo()
          .uploadRecordByDoctor(event.patientId, event.record);
      if (response.statusCode == 201) {
        emit(UploadRecordSuccess(record: MedicalRecord.fromMap(response.data)));
      } else {
        emit(UploadRecordError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UploadRecordError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UploadRecordError(message: e.response?.data["message"][0]));
            } else {
              emit(UploadRecordError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UploadRecordError(message: e.response?.data["message"][0]));
            } else {
              emit(UploadRecordError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UploadRecordError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(UploadRecordError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _updateRecord(UpdateRecord event, Emitter<RecordState> emit) async {
    emit(UpdatingRecord());
    try {
      final response =
          await RecordRepo().updateRecord(event.recordId, event.record);
      if (response.statusCode == 200) {
        emit(RecordUpdated(record: MedicalRecord.fromMap(response.data)));
      } else {
        emit(RecordUpdateError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordUpdateError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordUpdateError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordUpdateError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordUpdateError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordUpdateError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RecordUpdateError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordUpdateError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _getRequests(FetchAllRequest event, Emitter<RecordState> emit) async {
    emit(FetchingRequest());
    try {
      final response = await RecordRepo().getAllRequest();
      if (response.statusCode == 200) {
        emit(RequestFetched(
            requests: (response.data as List<dynamic>)
                .map((e) => RecordRequest.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(RequestError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RequestError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestError(message: e.response?.data["message"][0]));
            } else {
              emit(RequestError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestError(message: e.response?.data["message"][0]));
            } else {
              emit(RequestError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RequestError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RequestError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _updateRequest(
      UpdateRequestStatus event, Emitter<RecordState> emit) async {
    emit(UpdatingRequestStatus());
    try {
      final response = await RecordRepo()
          .approveOrRejectReq(event.requestId, event.value);
      if (response.statusCode == 200) {
        emit(RequestStatusUpdated(
          id: event.requestId,
          message: response.data["message"],
          value: event.value,
        ));
      } else {
        emit(RequestStatusError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RequestStatusError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestStatusError(message: e.response?.data["message"][0]));
            } else {
              emit(RequestStatusError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RequestStatusError(message: e.response?.data["message"][0]));
            } else {
              emit(RequestStatusError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RequestStatusError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RequestStatusError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _revokePermission(RevokePermission event, Emitter<RecordState> emit) async {
    emit(RevokingPermission());
    try {
      final response = await RecordRepo().revokePermission(event.requestId);
      if (response.statusCode == 200) {
        emit(PermissionRevoked());
      } else {
        emit(PermissionRevokeError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PermissionRevokeError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PermissionRevokeError(message: e.response?.data["message"][0]));
            } else {
              emit(PermissionRevokeError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PermissionRevokeError(message: e.response?.data["message"][0]));
            } else {
              emit(PermissionRevokeError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PermissionRevokeError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PermissionRevokeError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
