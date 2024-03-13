import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_event.dart';
import 'package:user_mobile_app/features/patients/bloc/patient_bloc/patient_state.dart';
import 'package:user_mobile_app/features/patients/data/repo/patient_repo.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

class MyPatientBloc extends Bloc<PatientEvent, PatientState> {
  MyPatientBloc() : super(PatientInitial()) {
    on<GetPatients>((event, emit) => getPatient(emit));
  }

  void getPatient(Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      Response response = await PatientRepo().getPatients();

      if (response.statusCode == 200) {
        emit(PatientLoaded(
          patients: (response.data as List<dynamic>)
              .map((e) => User.fromMap(e as Map<String, dynamic>))
              .toList(),
        ));
      } else {
        emit(PatientError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PatientError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PatientError(message: e.response?.data["message"][0]));
            } else {
              emit(PatientError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PatientError(message: e.response?.data["message"][0]));
            } else {
              emit(PatientError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PatientError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PatientError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
