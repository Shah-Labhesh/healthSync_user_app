import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_event.dart';
import 'package:user_mobile_app/features/home/bloc/doc_home_bloc/doc_home_state.dart';
import 'package:user_mobile_app/features/home/data/repo/home_repo.dart';

class DocHomeBloc extends Bloc<DocHomeEvent, DocHomeState> {
  DocHomeBloc() : super(DocHomeInitial()) {
    on<GetDocHome>((event, emit) => getDocHome(event, emit));
    on<RequestForAproval>((event, emit) => request(emit));
  }

  void getDocHome(GetDocHome event, Emitter<DocHomeState> emit) async {
    emit(DocHomeLoading());
    try {
      Response currentDoctor = await HomeRepo().currentUser();
      Response appointmentResponse = await HomeRepo().getDoctorAppointments();
      Response patientsResponse = await HomeRepo().getDoctorPatients();

      if (currentDoctor.statusCode == 200 &&
          appointmentResponse.statusCode == 200 &&
          patientsResponse.statusCode == 200) {
        emit(DocHomeLoaded(
          doctors: User.fromMap(currentDoctor.data),
          appointments: (appointmentResponse.data as List<dynamic>)
              .map((e) => Appointment.fromMap(e as Map<String, dynamic>))
              .toList(),
          patients: (patientsResponse.data as List<dynamic>)
              .map((e) => User.fromMap(e as Map<String, dynamic>))
              .toList(),
        ));
      } else {
        emit(DocHomeError(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(DocHomeError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocHomeError(message: e.response?.data["message"][0]));
            } else {
              emit(DocHomeError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(DocHomeError(message: e.response?.data["message"][0]));
            } else {
              emit(DocHomeError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(DocHomeError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(DocHomeError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }


  void request(Emitter<DocHomeState> emit) async {
    emit(RequestingAproval());
    try {
      Response response = await HomeRepo().requestForApproval();
      if (response.statusCode==201) {
        emit(AprovalRequested());
      } else {
        emit(ApprovalRequestFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ApprovalRequestFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ApprovalRequestFailed(message: e.response?.data["message"][0]));
            } else {
              emit(ApprovalRequestFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ApprovalRequestFailed(message: e.response?.data["message"][0]));
            } else {
              emit(ApprovalRequestFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ApprovalRequestFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ApprovalRequestFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}