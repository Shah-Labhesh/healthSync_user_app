import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';

abstract class DocHomeState {}

class DocHomeInitial extends DocHomeState {}

class DocHomeLoading extends DocHomeState {}

class DocHomeLoaded extends DocHomeState {
  final User doctors;
  final List<Appointment> appointments;
  final List<User> patients;
  DocHomeLoaded(
      {required this.doctors,
      required this.appointments,
      required this.patients});
}

class DocHomeError extends DocHomeState {
  final String message;
  DocHomeError({required this.message});
}

class TokenExpired extends DocHomeState {}
