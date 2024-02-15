import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/my_appointment_bloc/my_appointment_state.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/appointment/data/repo/appointment_repo.dart';

class MyAppointmentBloc extends Bloc<MyAppointmentEvent, MyAppointmentState> {
  MyAppointmentBloc() : super(MyAppointmentInitial()) {
    on<FetchMyAppointmentEvent>((event, emit) => myAppointment(emit));

  }

  void myAppointment(Emitter<MyAppointmentState> emit) async {
    emit(MyAppointmentLoading());
    try {
      final response = await AppointmentRepo().getMyAppointments();
      if (response.statusCode == 200) {
        emit(MyAppointmentLoaded(data: (response.data as List<dynamic>).map((e) => Appointment.fromMap(e as Map<String,dynamic>)).toList()));
      } else {
        emit(MyAppointmentLoadFailed(message: response.data['message']));
      }
      
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(MyAppointmentLoadFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(MyAppointmentLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(MyAppointmentLoadFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(MyAppointmentLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(MyAppointmentLoadFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(MyAppointmentLoadFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(MyAppointmentLoadFailed(
            message: 'Connection timed out. Please try again later'));
      }
      
    }
  }
}