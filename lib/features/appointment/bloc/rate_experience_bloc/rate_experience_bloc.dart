
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/appointment/bloc/rate_experience_bloc/rate_experience_event.dart';
import 'package:user_mobile_app/features/appointment/bloc/rate_experience_bloc/rate_experience_state.dart';
import 'package:user_mobile_app/features/appointment/data/repo/rating_repo.dart';

class RateExperienceBloc extends Bloc<RateExperienceEvent, RateExperienceState> {
  RateExperienceBloc() : super(RateExperienceInitial()) {
    on<RateExperience>((event, emit) => _onRateExperience(event, emit));
  }

  void _onRateExperience(RateExperience event, Emitter<RateExperienceState> emit) async {
    emit(RateExperienceLoading());
    try {
      final response = await RatingRepo().rateExperience(data: event.data, id: event.id);
      if (response.statusCode == 201) {
        emit(RateExperienceSuccess(message: response.data['message']));
      } else {
        emit(RateExperienceFailure(message: response.data['message']));
      }
      
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(RateExperienceFailure(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RateExperienceFailure(message: e.response?.data["message"][0]));
            } else {
              emit(RateExperienceFailure(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(RateExperienceFailure(message: e.response?.data["message"][0]));
            } else {
              emit(RateExperienceFailure(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(RateExperienceFailure(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(RateExperienceFailure(
            message: 'Connection timed out. Please try again later'));
      }
      
    }
  }
}