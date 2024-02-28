import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_event.dart';
import 'package:user_mobile_app/features/payment/bloc/make_payment_bloc/make_payment_state.dart';
import 'package:user_mobile_app/features/payment/data/repo/payment_repo.dart';

class MakePaymentBloc extends Bloc<MakePaymentEvent, MakePaymentState> {
  MakePaymentBloc() : super(MakePaymentInitial()) {
    on<InitiatePayment>((event, emit) => initiatePayment(event, emit));
    on<ConfirmPayment>((event, emit) => confirmPayment(event, emit));
  }

  void initiatePayment(InitiatePayment event, Emitter<MakePaymentState> emit) async {
    emit(MakePaymentLoading());
    try {
      Response response = await PaymentRepo().initiatePayment(data: event.data);
      if (response.statusCode == 201) {
        emit(InitiatePaymentSuccess(khaltiToken: response.data['khalti_token']));
      } else {
        emit(InitiatePaymentFailure(message: response.data['message']));
      }
      
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(InitiatePaymentFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
             if (e.response?.data["message"].runtimeType != String) {
              emit(InitiatePaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(InitiatePaymentFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(InitiatePaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(InitiatePaymentFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(InitiatePaymentFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(InitiatePaymentFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void confirmPayment(ConfirmPayment event, Emitter<MakePaymentState> emit) async {
    emit(MakePaymentLoading());
    try {
      Response response = await PaymentRepo().confirmPayment(data: event.data);
      if (response.statusCode == 201) {
        emit(ConfirmPaymentSuccess());
      } else {
        emit(ConfirmPaymentFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ConfirmPaymentFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
             if (e.response?.data["message"].runtimeType != String) {
              emit(ConfirmPaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(ConfirmPaymentFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ConfirmPaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(ConfirmPaymentFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ConfirmPaymentFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ConfirmPaymentFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}