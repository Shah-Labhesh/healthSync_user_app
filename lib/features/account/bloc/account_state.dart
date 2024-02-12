import 'package:user_mobile_app/features/account/data/model/user.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final User data;

  AccountLoaded({required this.data});
}

class AccountLoadFailed extends AccountState {
  String message = '';

  AccountLoadFailed({required this.message});
}

class LoggingOut extends AccountState {}

class LoggedOut extends AccountState {}

class LogOutFailed extends AccountState {
  String message = '';

  LogOutFailed({required this.message});
}

class TokenExpired extends AccountState {}
