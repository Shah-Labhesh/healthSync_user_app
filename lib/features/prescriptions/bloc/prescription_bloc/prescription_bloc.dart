import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_event.dart';
import 'package:user_mobile_app/features/prescriptions/bloc/prescription_bloc/prescription_state.dart';
import 'package:user_mobile_app/features/prescriptions/data/model/prescription.dart';
import 'package:user_mobile_app/features/prescriptions/data/repo/prescription_repo.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  PrescriptionBloc() : super(PrescriptionInitial()) {
    on<FetchPatientsEvent>((event, emit)  => _getPatientList(event, emit));
    on<FetchPrescriptionsEvent>((event, emit) => _getPrescriptions(event, emit));
    on<UploadPrescriptionEvent>((event, emit) => _uploadPrescription(event, emit));
  }

  void  _getPatientList(FetchPatientsEvent event, Emitter<PrescriptionState> emit) async {
    emit(PatientListLoading());
    try{
      final response = await PrescriptionRepo().getPatientList();
      if (response.statusCode == 200) {
        final List<User> patients = (response.data as List)
            .map((e) => User.fromMap(e))
            .toList();
        emit(PatientListLoaded(patients: patients));
      } else {
        emit(PatientListError(message: response.data["message"]));
      }
    }catch(e){
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

  void _getPrescriptions(FetchPrescriptionsEvent event, Emitter<PrescriptionState> emit) async {
    emit(PrescriptionLoading());
    try{
      final response = await PrescriptionRepo().getPrescriptions();
      if (response.statusCode == 200) {
        final List<Prescription> prescriptions = (response.data as List)
            .map((e) => Prescription.fromMap(e))
            .toList();
        emit(PrescriptionLoaded(prescriptions: prescriptions));
      } else {
        emit(PrescriptionError(message: response.data["message"]));
      }
    }catch(e){
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
              emit(PrescriptionError(message: e.response?.data["message"][0]));
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

  void _uploadPrescription(UploadPrescriptionEvent event, Emitter<PrescriptionState> emit) async {
    emit(UploadingPrescription());
    try{
      final response = await PrescriptionRepo().uploadPrescription(event.prescription);
      if (response.statusCode == 201) {
        final Prescription prescription = Prescription.fromMap(response.data);
        emit(PrescriptionUploaded(prescription: prescription));
      } else {
        emit(PrescriptionUploadError(message: response.data["message"]));
      }
    }catch(e){
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PrescriptionUploadError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PrescriptionUploadError(message: e.response?.data["message"][0]));
            } else {
              emit(PrescriptionUploadError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PrescriptionUploadError(message: e.response?.data["message"][0]));
            } else {
              emit(PrescriptionUploadError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PrescriptionUploadError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PrescriptionUploadError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}