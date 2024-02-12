import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';

abstract class UserHomeState {}

class UserHomeInitial extends UserHomeState {}

class UserHomeLoading extends UserHomeState {}

class UserHomeLoaded extends UserHomeState {
  final User user;
  final List<Appointment> appointment;
  final List<User> doctors;
  final List<Specialities> specialities;

  UserHomeLoaded(
      {required this.appointment,
      required this.user,
      required this.doctors,
      required this.specialities});
}

class UserHomeLoadFailed extends UserHomeState {
  String message = '';

  UserHomeLoadFailed({required this.message});
}

class TokenExpired extends UserHomeState {}

class ToggleFavouriteLoading extends UserHomeState {}

class ToggleFavouriteSuccess extends UserHomeState {
  final String doctorId;

  ToggleFavouriteSuccess({required this.doctorId});
}

class ToggleFavouriteFailed extends UserHomeState {
  final String message;

  ToggleFavouriteFailed({required this.message});
}