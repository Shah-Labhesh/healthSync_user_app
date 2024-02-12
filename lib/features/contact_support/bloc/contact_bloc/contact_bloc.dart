import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_event.dart';
import 'package:user_mobile_app/features/contact_support/bloc/contact_bloc/contact_state.dart';
import 'package:user_mobile_app/features/contact_support/data/repo/contact_repo.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<ContactFormSubmitted>((event, emit) => _contact(emit, event));
  }

  _contact(Emitter<ContactState> emit, ContactFormSubmitted event) async {
    emit(ContactLoading());
    try {
      Response response = await ContactRepo()
          .sendContactUs(email: event.email, message: event.message);
      if (response.statusCode == 201) {
        emit(
            ContactSuccess(message: 'Your message has been sent successfully'));
      } else {
        emit(ContactFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ContactFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            emit(ContactFailed(message: e.response?.data["message"]));
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ContactFailed(message: e.response?.data["message"][0]));
            } else {
              emit(ContactFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ContactFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ContactFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
