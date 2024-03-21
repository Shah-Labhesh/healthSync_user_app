

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_event.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_state.dart';
import 'package:user_mobile_app/features/favorite/data/repo/favorite_repo.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<FavoriteEvent>((event, emit) => getFavorite(emit, event));
    on<ToggleFavouriteEvent>((event, emit) => toggleFavourite(emit, event));
  }

  void getFavorite(Emitter<FavoriteState> emit, FavoriteEvent event) async {
    emit(FavoriteLoading());
    try {
      Response response = await FavoriteRepo().getFavorite();
      if (response.statusCode == 200) {
        emit(FavoriteLoaded(
          doctors: (response.data as List)
              .map((e) => User.fromMap(e))
              .toList(),
        ));
      } else {
        emit(FavoriteLoadFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(FavoriteLoadFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FavoriteLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(FavoriteLoadFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(FavoriteLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(FavoriteLoadFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(FavoriteLoadFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(FavoriteLoadFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }


  void toggleFavourite(
      Emitter<FavoriteState> emit, ToggleFavouriteEvent event) async {
    emit(ToggleFavouriteLoading());
    try {
      Response response = await FavoriteRepo().toggleFavourite(event.doctorId);
      if (response.statusCode == 200) {
        emit(ToggleFavouriteSuccess());
      } else {
        emit(ToggleFavouriteFailed(
            message: 'Something went wrong. Please try again later'));
      }
    } catch (e) {
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
              emit(ToggleFavouriteFailed(
                  message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(ToggleFavouriteFailed(
                  message: e.response?.data["message"][0]));
            } else {
              emit(ToggleFavouriteFailed(
                  message: e.response?.data["message"]));
            }
          }
        } else {
          emit(ToggleFavouriteFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(ToggleFavouriteFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}