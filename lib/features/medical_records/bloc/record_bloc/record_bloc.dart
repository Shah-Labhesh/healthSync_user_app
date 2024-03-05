import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_state.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/medical_records/data/repo/record_repo.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(RecordInitial()) {
    on<FetchRecords>((event, emit) => _getrecords(event, emit));
    on<UploadRecordEvent>((event, emit) => _uploadRecord(event, emit));
    on<FetchPatientList>((event, emit) => _getPatientList(event, emit));
    on<UploadRecordByDoctor>(
        (event, emit) => _uploadRecordByDoctor(event, emit));
    on<FetchDoctorList>((event, emit) => _getDoctorList(event, emit));
    on<ShareRecord>((event, emit) => _shareRecord(event, emit));
    on<RevokeSharedRecord>((event, emit) => _revokeSharedRecord(event, emit));
    on<UpdateRecord>((event, emit) => _updateRecord(event, emit));
  }

  void _getrecords(FetchRecords event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final response = await RecordRepo().getRecords(sort: event.sort);
      if (response.statusCode == 200) {
        if (event.sort == 'SHARED') {
          emit(ShareRecordLoaded(
              records: (response.data as List<dynamic>)
                  .map((e) => ShareMedicalRecord.fromMap(e as Map<String, dynamic>))
                  .toList()));
        } else {
          emit(RecordLoaded(
              records: (response.data as List<dynamic>)
                  .map((e) => MedicalRecord.fromMap(e as Map<String, dynamic>))
                  .toList()));
        }
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

  void _getPatientList(
      FetchPatientList event, Emitter<RecordState> emit) async {
    emit(PatientListLoading());
    try {
      final response = await RecordRepo().getPatientList();
      if (response.statusCode == 200) {
        emit(PatientListLoaded(
            patients: (response.data as List<dynamic>)
                .map((e) => User.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(PatientListError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PatientListError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PatientListError(message: e.response?.data["message"][0]));
            } else {
              emit(PatientListError(message: e.response?.data["message"]));
            }
          } else {
             if (e.response?.data["message"].runtimeType != String) {
              emit(PatientListError(message: e.response?.data["message"][0]));
            } else {
              emit(PatientListError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PatientListError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PatientListError(
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

  void _getDoctorList(FetchDoctorList event, Emitter<RecordState> emit) async {
    emit(FetchingDoctorList());
    try {
      final response = await RecordRepo().getDoctorList();
      if (response.statusCode == 200) {
        emit(DoctorListFetched(
            doctors: (response.data as List<dynamic>)
                .map((e) => User.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(DoctorListError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DoctorListError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DoctorListError(message: e.response?.data["message"][0]));
            } else {
              emit(DoctorListError(message: e.response?.data["message"]));
            }
          } else {
             if (e.response?.data["message"].runtimeType != String) {
              emit(DoctorListError(message: e.response?.data["message"][0]));
            } else {
              emit(DoctorListError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DoctorListError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(DoctorListError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _shareRecord(ShareRecord event, Emitter<RecordState> emit) async {
    emit(SharingRecord());
    try {
      final response =
          await RecordRepo().shareRecord(event.recordId, event.doctorId);
      if (response.statusCode == 201) {
        emit(RecordShared(message: 'Record shared successfully'));
      } else {
        emit(RecordShareError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordShareError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordShareError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordShareError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordShareError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordShareError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RecordShareError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordShareError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _revokeSharedRecord(
      RevokeSharedRecord event, Emitter<RecordState> emit) async {
    emit(SharingRecord());
    try {
      final response = await RecordRepo().revokeSharedRecord(event.recordId);
      if (response.statusCode == 200) {
        emit(RecordShared(message: 'Record revoked successfully'));
      } else {
        emit(RecordShareError(message: 'Something went wrong'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordShareError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordShareError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordShareError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordShareError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordShareError(message: e.response?.data["message"]));
            }
            
          }
        } else {
          emit(RecordShareError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _updateRecord(UpdateRecord event, Emitter<RecordState> emit) async {
    emit(UpdatingRecord());
    try {
      final response = await RecordRepo().updateRecord(event.recordId, event.record);
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
}
