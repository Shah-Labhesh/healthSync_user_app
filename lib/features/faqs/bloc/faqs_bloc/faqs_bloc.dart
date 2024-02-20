import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_event.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_state.dart';
import 'package:user_mobile_app/features/faqs/data/model/faq.dart';
import 'package:user_mobile_app/features/faqs/data/repo/faq_repo.dart';

class FAQBloc extends Bloc<FAQsEvent, FAQsState> {
  FAQBloc() : super(FAQsInitial()) {
    on<GetFAQs>((event, emit) => _onGetFAQs(emit));
  }


  void _onGetFAQs(Emitter<FAQsState> emit) async {
    emit(FAQsLoading());
    try{
      Response response = await FAQRepo().getFAQs();
      if (response.statusCode == 200) {
        emit(FAQsLoaded(faqs: (response.data as List).map((e) => FaQs.fromMap(e)).toList()));
      } else {
        emit(FAQsError(
            message: 'Something went wrong. Please try again later'));
      }
    }catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(FAQsError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FAQsError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FAQsError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FAQsError(
                  message: e.response?.data["message"][0]));
            } else {
              emit(FAQsError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(FAQsError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(FAQsError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}