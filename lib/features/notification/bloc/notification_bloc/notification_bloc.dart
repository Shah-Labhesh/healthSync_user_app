import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_event.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_state.dart';
import 'package:user_mobile_app/features/notification/data/model/notification.dart';
import 'package:user_mobile_app/features/notification/data/repo/notification_repo.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<FetchNotification>((event, emit) => _getNotifications(event, emit));
    on<FetchUnreadNotificationCount>(
        (event, emit) => _getUnreadNotificationCount(event, emit));
    on<MarkNotificationAsRead>((event, emit) => _markNotificationAsRead(event, emit));
  }

  void _getNotifications(FetchNotification event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final response = await NotificationRepo().getNotifications();
      if (response.statusCode == 200) {
       
        emit(NotificationLoaded(notifications:  (response.data as List).map((e) => Notifications.fromMap(e as Map<String, dynamic>)).toList()));
      } else {
        emit(NotificationError(message: 'Failed to load notifications'));
      }
    } catch (e) {
       if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(NotificationError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(NotificationError(message: e.response?.data["message"][0]));
            } else {
              emit(NotificationError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(NotificationError(message: e.response?.data["message"][0]));
            } else {
              emit(NotificationError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(NotificationError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(NotificationError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _getUnreadNotificationCount(
      FetchUnreadNotificationCount event, Emitter<NotificationState> emit) async {
    emit(LoadingCount());
    try {
      final response = await NotificationRepo().getNotificationCount();
      if (response.statusCode == 200) {
        emit(CountLoaded(count: response.data['count'] as int));
      } else {
        emit(CountError(message: 'Failed to load notification count'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(CountError(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
            if (e.response?.data["message"].runtimeType != String) {
              emit(CountError(message: e.response?.data["message"][0]));
            } else {
              emit(CountError(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(CountError(message: e.response?.data["message"][0]));
            } else {
              emit(CountError(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(CountError(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(CountError(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }

  void _markNotificationAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    emit(LoadingMarkRead());
    try {
      final response = await NotificationRepo().markRead();
      if (response.statusCode == 201) {
        emit(MarkReadSuccess());
      } else {
        emit(MarkReadFailed(message: 'Failed to mark notification as read'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 522) {
            emit(MarkReadFailed(
                message: 'Connection timed out. Please try again later'));
          } else if (statusCode == 401) {
            emit(TokenExpired());
          } else if (statusCode! >= 500 || statusCode >= 402) {
             if (e.response?.data["message"].runtimeType != String) {
              emit(MarkReadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(MarkReadFailed(message: e.response?.data["message"]));
            }
          } else {
            if (e.response?.data["message"].runtimeType != String) {
              emit(MarkReadFailed(message: e.response?.data["message"][0]));
            } else {
              emit(MarkReadFailed(message: e.response?.data["message"]));
            }
          }
        } else {
          emit(MarkReadFailed(
              message: 'Something went wrong. Please try again later'));
        }
      } else {
        emit(MarkReadFailed(
            message: 'Something went wrong. Please try again later'));
      }
    }
  }
}