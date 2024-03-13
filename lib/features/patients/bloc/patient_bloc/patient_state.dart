import 'package:user_mobile_app/features/account/data/model/user.dart';


abstract class PatientState{}

class PatientInitial extends PatientState{}

class PatientLoading extends PatientState{}

class PatientLoaded extends PatientState{
  final List<User> patients;
  PatientLoaded({required this.patients});
}

class PatientError extends PatientState{
  final String message;
  PatientError({required this.message});
}

class TokenExpired extends PatientState{}