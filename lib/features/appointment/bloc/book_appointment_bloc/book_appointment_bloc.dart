import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/book_appointment_bloc/book_appointment_state.dart';
import 'package:user_mobile_app/features/appointment/data/repo/appointment_repo.dart';
import 'package:user_mobile_app/features/slots/data/model/slot.dart';

class BookAppointmentBloc
    extends Bloc<BookAppointmentEvent, BookAppointmentState> {
  BookAppointmentBloc() : super(BookAppointmentInitial()) {
    on<FetchSlots>((event, emit) => fetchSlots(event, emit));
    on<BookAppointment>((event, emit) => bookAppointment(event, emit));
  }

  void fetchSlots(FetchSlots event, Emitter<BookAppointmentState> emit) async {
    emit(FetchSlotsLoading());
    try {
      Response response =
          await AppointmentRepo().getSlots(doctorId: event.doctorId);
      if (response.statusCode == 200) {
        emit(FetchSlotsSuccess(
            slots: (response.data as List<dynamic>)
                .map((e) => Slots.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(FetchSlotsFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(FetchSlotsFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FetchSlotsFailure(message: e.response?.data["message"][0]));
            } else {
              emit(FetchSlotsFailure(message: e.response?.data["message"]));
            }
          } else {
            emit(FetchSlotsFailure(message: e.response?.data["message"]));
          }
        } else {
          emit(FetchSlotsFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        print(e);
        emit(FetchSlotsFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void bookAppointment(
      BookAppointment event, Emitter<BookAppointmentState> emit) async {
    emit(BookAppointmentLoading());
    try {
      Response response = await AppointmentRepo().bookAppointment(data: event.appointmentData);
      if (response.statusCode == 201) {
        emit(BookAppointmentSuccess(message: response.data['message']));
      } else {
        emit(BookAppointmentFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(BookAppointmentFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(BookAppointmentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(BookAppointmentFailure(message: e.response?.data["message"]));
            }
          } else {
            emit(BookAppointmentFailure(message: e.response?.data["message"]));
          }
        } else {
          emit(BookAppointmentFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        print(e);
        emit(BookAppointmentFailure(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}
