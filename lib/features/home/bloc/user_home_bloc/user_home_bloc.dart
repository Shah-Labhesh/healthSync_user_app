import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_event.dart';
import 'package:user_mobile_app/features/home/bloc/user_home_bloc/user_home_state.dart';
import 'package:user_mobile_app/features/home/data/repo/home_repo.dart';

class UserHomeBloc extends Bloc<UserHomeEvent, UserHomeState> {
  UserHomeBloc() : super(UserHomeInitial()) {
    on<FetchUserHomeEvent>((event, emit) => getHome(emit, event));
    on<ToggleFavouriteEvent>((event, emit) => toggleFavourite(emit, event));
  }

  void getHome(Emitter<UserHomeState> emit, FetchUserHomeEvent event) async {
    emit(UserHomeLoading());
    try {
      Response specialitiesResponse = await HomeRepo().getSpeciality();
      Response doctorsResponse = await HomeRepo().getDoctors();
      Response appointmentsResponse = await HomeRepo().getMyAppointments();
      Response userResponse = await HomeRepo().currentUser();

      if (specialitiesResponse.statusCode == 200 &&
          doctorsResponse.statusCode == 200 &&
          appointmentsResponse.statusCode == 200) {
        emit(
          UserHomeLoaded(
            appointment: (appointmentsResponse.data as List)
                .map((e) => Appointment.fromMap(e))
                .toList(),
            user: User.fromMap(userResponse.data),
            doctors: (doctorsResponse.data as List)
                .map((e) => User.fromMap(e))
                .toList(),
            specialities: (specialitiesResponse.data as List)
                .map((e) => Specialities.fromMap(e))
                .toList(),
          ),
        );
      } else {
        emit(UserHomeLoadFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(UserHomeLoadFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UserHomeLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(UserHomeLoadFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(UserHomeLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(UserHomeLoadFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(UserHomeLoadFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        print(e);

        emit(UserHomeLoadFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  toggleFavourite(
      Emitter<UserHomeState> emit, ToggleFavouriteEvent event) async {
    emit(ToggleFavouriteLoading());
    try {
      Response response = await HomeRepo().toggleFavourite(event.doctorId);
      if (response.statusCode == 200) {
        emit(ToggleFavouriteSuccess(doctorId: event.doctorId));
      } else {
        emit(ToggleFavouriteFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      print(e);
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(ToggleFavouriteFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
             if (e.response?.data["message"].runtimeType != String) {
              emit(ToggleFavouriteFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ToggleFavouriteFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ToggleFavouriteFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ToggleFavouriteFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          print(e);
          emit(ToggleFavouriteFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        print(e);
        emit(ToggleFavouriteFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}
