import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/firebase.dart';
import 'package:user_mobile_app/features/account/bloc/account_event.dart';
import 'package:user_mobile_app/features/account/bloc/account_state.dart';
import 'package:user_mobile_app/features/account/data/repo/account_repo.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<FetchCurrentUserEvent>((event, emit) => getCurrentUser(event, emit));
    on<LogoutEvent>((event, emit) => logOut(event, emit));
  }

  void getCurrentUser(
      FetchCurrentUserEvent event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      Response response = await AccountRepo().currentUser();
      if (response.statusCode == 200) {
        emit(AccountLoaded(data: User.fromMap(response.data)));
      } else {
        emit(AccountLoadFailed(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(AccountLoadFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(AccountLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(AccountLoadFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(AccountLoadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(AccountLoadFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(AccountLoadFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(AccountLoadFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }

  void logOut(LogoutEvent event, Emitter<AccountState> emit) async {
    emit(LoggingOut());
    try {
      final deviceToken = await FirebaseService.getToken();
      Response response = await AccountRepo().logout(deviceToken: deviceToken);
      if (response.statusCode == 200) {
        emit(LoggedOut());
      } else {
        emit(LogOutFailed(message: response.data['message']));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(LogOutFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(LogOutFailed(message: e.response?.data["message"][0]));
            } else {
              emit(LogOutFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(LogOutFailed(message: e.response?.data["message"][0]));
            } else {
              emit(LogOutFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(LogOutFailed(
              message: 'Connection timed out. Please try again later'));
        }
      } else {
        emit(LogOutFailed(
            message: 'Connection timed out. Please try again later'));
      }
    }
  }
}
