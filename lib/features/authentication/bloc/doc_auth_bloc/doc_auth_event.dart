// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';

abstract class DocAuthEvent {}

class RegisterDoctorEvent extends DocAuthEvent {
  final Map<String, String> credentials;

  RegisterDoctorEvent({required this.credentials});
}

abstract class DocAddressEvent {}

class AddAddressEvent extends DocAddressEvent {
  final String doctorId;
  final Map<String, dynamic> address;

  AddAddressEvent({
    required this.doctorId,
    required this.address,
  });
}

abstract class DocDetailsEvent {}

class AddDocDetailsEvent extends DocDetailsEvent {
  final String doctorId;
  final FormData details;

  AddDocDetailsEvent({
    required this.doctorId,
    required this.details,
  });
}

class FetchSpecialitiesEvent extends DocDetailsEvent {}

abstract class MoreDocDetailsEvent {}

class AddMoreDocDetailsEvent extends MoreDocDetailsEvent {
  final String doctorId;
  final Map<String, dynamic> details;

  AddMoreDocDetailsEvent({
    required this.doctorId,
    required this.details,
  });
}

class GetDocQualificationEvent extends MoreDocDetailsEvent {
  final String doctorId;

  GetDocQualificationEvent({
    required this.doctorId,
  });
}

class AddDocQualificationEvent extends MoreDocDetailsEvent {
  final String doctorId;
  final FormData qualification;

  AddDocQualificationEvent({
    required this.doctorId,
    required this.qualification,
  });
}

class EditDocQualificationEvent extends MoreDocDetailsEvent {
  final String doctorId;
  final FormData qualification;
  final String qualificationId;

  EditDocQualificationEvent({
    required this.doctorId,
    required this.qualification,
    required this.qualificationId,
  });
}

class DeleteDocQualificationEvent extends MoreDocDetailsEvent {
  final String doctorId;
  final String qualificationId;

  DeleteDocQualificationEvent({
    required this.doctorId,
    required this.qualificationId,
  });
}
