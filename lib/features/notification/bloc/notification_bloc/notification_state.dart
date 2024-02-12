import 'package:user_mobile_app/features/notification/data/model/notification.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}

class NotificationLoaded extends NotificationState {
  final List<Notifications> notifications;

  NotificationLoaded({required this.notifications});
}

class LoadingCount extends NotificationState {}

class CountLoaded extends NotificationState {
  final int count;

  CountLoaded({required this.count});
}

class CountError extends NotificationState {
  final String message;

  CountError({required this.message});
}

class LoadingMarkRead extends NotificationState {}

class MarkReadSuccess extends NotificationState {
  
}

class MarkReadFailed extends NotificationState {
  final String message;

  MarkReadFailed({required this.message});
}

class TokenExpired extends NotificationState {}

