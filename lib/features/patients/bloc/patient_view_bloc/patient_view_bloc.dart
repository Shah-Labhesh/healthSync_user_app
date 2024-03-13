import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/medical_records/data/model/medical_record.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_event.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_view_bloc/patient_view_state.dart';
import 'package:user_mobile_app/features/patients/data/repo/patient_repo.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';

class PatientViewBloc extends Bloc<PatientViewEvent, PatientViewState> {
  PatientViewBloc() : super(PatientViewInitial()) {
    on<FetchMedicalRecords>((event, emit)  => fetchRecord(event, emit));
    on<FetchPrescriptions>((event, emit) => fetchPrescription(event, emit));
    on<RequestPermissonForPrescription>((event, emit) => requestPrescriptionPermission(event, emit));
    on<RequestPermissonForRecords>((event, emit) => requestRecordPermission(event, emit));
  }
  
  fetchRecord(FetchMedicalRecords event, Emitter<PatientViewState> emit) async{
     emit(RecordsLoading());
    try {
      Response response = await PatientRepo().getPatientRecord(patientId: event.patientId);

      if (response.statusCode == 200) {
        emit(RecordsLoaded(
          medicalRecords: (response.data as List<dynamic>)
              .map((e) => ShareMedicalRecord.fromMap(e as Map<String, dynamic>))
              .toList(),
        ));
      } else {
        emit(RecordsError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordsError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordsError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordsError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response!.data["message"][0].toString().contains('permission')) {
                emit(NoPremissionForRecords(message: e.response?.data["message"][0]));
              } else {
                emit(RecordsError(message: e.response?.data["message"][0]));
              }
          }
        } else {
          emit(RecordsError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordsError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void fetchPrescription(FetchPrescriptions event, Emitter<PatientViewState> emit) async {
    emit(PrescriptionLoading());
    try {
      Response response = await PatientRepo().getPatientPrescriptions(patientId: event.patientId);

      if (response.statusCode == 200) {
        emit(PrescriptionLoaded(
          prescriptions: (response.data as List<dynamic>)
              .map((e) => Prescription.fromMap(e as Map<String, dynamic>))
              .toList(),
        ));
      } else {
        emit(PrescriptionError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PrescriptionError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PrescriptionError(message: e.response?.data["message"][0]));
            } else {
              emit(PrescriptionError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              if (e.response!.data["message"][0].toString().contains('permission')) {
                emit(NoPremissionForPrescription(message: e.response?.data["message"][0]));
              } else {
                emit(PrescriptionError(message: e.response?.data["message"][0]));
              }
            } else {
              emit(PrescriptionError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PrescriptionError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PrescriptionError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void requestPrescriptionPermission(RequestPermissonForPrescription event, Emitter<PatientViewState> emit) async {
    emit(RequestingPrescriptionPermission());
    try {
      Response response = await PatientRepo().requestPermission(userId: event.patientId);

      if (response.statusCode == 200) {
        emit(PermissionRequested(
          message: response.data["message"],
        ));
      } else {
        emit(PermissionRequestError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PermissionRequestError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PermissionRequestError(message: e.response?.data["message"][0]));
            } else {
              emit(PermissionRequestError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PermissionRequestError(message: e.response?.data["message"][0]));
            } else {
              emit(PermissionRequestError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PermissionRequestError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PermissionRequestError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void requestRecordPermission(RequestPermissonForRecords event, Emitter<PatientViewState> emit) async {
    emit(RequestingRecordPermission());
    try {
      Response response = await PatientRepo().requestRecordPermission(userId: event.patientId);

      if (response.statusCode == 200) {
        emit(RecordPermissionRequested(
          message: response.data["message"],
        ));
      } else {
        emit(RecordPermissionRequestError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RecordPermissionRequestError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordPermissionRequestError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordPermissionRequestError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RecordPermissionRequestError(message: e.response?.data["message"][0]));
            } else {
              emit(RecordPermissionRequestError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RecordPermissionRequestError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(RecordPermissionRequestError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}