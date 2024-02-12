import 'package:user_mobile_app/features/appointment/data/model/appointment.dart';

abstract class MyAppointmentState {}

class MyAppointmentInitial extends MyAppointmentState {}


class MyAppointmentLoading extends MyAppointmentState {}

class MyAppointmentLoaded extends MyAppointmentState {
  final List<Appointment> data;

  MyAppointmentLoaded({required this.data});
}

class MyAppointmentLoadFailed extends MyAppointmentState {
  String message = '';

  MyAppointmentLoadFailed({required this.message});
}

class TokenExpired extends MyAppointmentState {}