import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/authentication/data/model/Specialities.dart';

abstract class DocAuthState {}

class DocRegisterInitial extends DocAuthState {}

class DocRegisterLoading extends DocAuthState {}

class DocRegisterSuccess extends DocAuthState {
  final String id;

  DocRegisterSuccess({required this.id});
}

class DocRegisterFailure extends DocAuthState {
  final String message;

  DocRegisterFailure({required this.message});
}

abstract class DocAddressState {}

class DocAddressInitial extends DocAddressState {}

class DocAddressLoading extends DocAddressState {}

class DocAddressSuccess extends DocAddressState {}

class DocAddressFailure extends DocAddressState {
  final String message;

  DocAddressFailure({required this.message});
}


abstract class DocDetailsState {}

class DocDetailsInitial extends DocDetailsState {}

class DocDetailsLoading extends DocDetailsState {}

class DocDetailsSuccess extends DocDetailsState {}

class DocDetailsFailure extends DocDetailsState {
  final String message;

  DocDetailsFailure({required this.message});
}

class SpecialitiesLoading extends DocDetailsState {}

class FetchSpecialitiesSuccess extends DocDetailsState {
  final List<Specialities> specialities;

  FetchSpecialitiesSuccess({required this.specialities});
}

class FetchSpecialitiesFailure extends DocDetailsState {
  final String message;

  FetchSpecialitiesFailure({required this.message});
}

abstract class MoreDocDetailsState {}

class MoreDocDetailsInitial extends MoreDocDetailsState {}

class MoreDocDetailsLoading extends MoreDocDetailsState {}

class MoreDocDetailsSuccess extends MoreDocDetailsState {}

class MoreDocDetailsFailure extends MoreDocDetailsState {
  final String message;

  MoreDocDetailsFailure({required this.message});
}

class AddDocQualificationSuccess extends MoreDocDetailsState {
  final String qualificationId;

  AddDocQualificationSuccess({required this.qualificationId});
}

class AddDocQualificationFailure extends MoreDocDetailsState {
  final String message;

  AddDocQualificationFailure({required this.message});
}

class EditDocQualificationSuccess extends MoreDocDetailsState {}

class EditDocQualificationFailure extends MoreDocDetailsState {
  final String message;

  EditDocQualificationFailure({required this.message});
}

class DeleteDocQualificationSuccess extends MoreDocDetailsState {}

class DeleteDocQualificationFailure extends MoreDocDetailsState {
  final String message;

  DeleteDocQualificationFailure({required this.message});
}

class GetDocQualificationSuccess extends MoreDocDetailsState {
  final List<DocQualification> qualifications;

  GetDocQualificationSuccess({required this.qualifications});
}

class GetDocQualificationFailure extends MoreDocDetailsState {
  final String message;

  GetDocQualificationFailure({required this.message});
}

