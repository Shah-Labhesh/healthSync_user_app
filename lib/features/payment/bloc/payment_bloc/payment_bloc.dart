import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_event.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_state.dart';
import 'package:user_mobile_app/features/payment/data/model/payment.dart';
import 'package:user_mobile_app/features/payment/data/repo/payment_repo.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<GetMyPayments>((event, emit) => _getPayments(event, emit));
    on<UpdateKhalti>((event, emit) => _updateKhalti(event, emit));
  }

  void _getPayments(GetMyPayments event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      Response response = await PaymentRepo().myPayments(sort: event.sort);
      if (response.statusCode == 200) {
        emit(PaymentSuccess(
            payments: (response.data as List<dynamic>)
                .map((e) => Payment.fromMap(e as Map<String, dynamic>))
                .toList()));
      } else {
        emit(PaymentFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(PaymentFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(PaymentFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(PaymentFailure(message: e.response?.data["message"][0]));
            } else {
              emit(PaymentFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(PaymentFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(PaymentFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _updateKhalti(UpdateKhalti event, Emitter<PaymentState> emit) async {
    emit(UpdatingKhalti());
    try {
      Response response = await PaymentRepo().updateKhalti(khalti: event.khalti);
      if (response.statusCode == 200) {
        emit(KhaltiUpdated(
          khalti: event.khalti,
        ));
      } else {
        emit(KhaltiUpdateFailure(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(KhaltiUpdateFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(KhaltiUpdateFailure(message: e.response?.data["message"][0]));
            } else {
              emit(KhaltiUpdateFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(KhaltiUpdateFailure(message: e.response?.data["message"][0]));
            } else {
              emit(KhaltiUpdateFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(KhaltiUpdateFailure(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(KhaltiUpdateFailure(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}
