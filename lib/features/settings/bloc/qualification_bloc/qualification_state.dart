import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';

abstract class QualificationState {}

class QualificationInitial extends QualificationState {}

class QualificationLoading extends QualificationState {}

class QualificationSuccess extends QualificationState {
  final List<DocQualification> qualifications;
  QualificationSuccess({required this.qualifications});
}


class QualificationFailure extends QualificationState {
  final String message;
  QualificationFailure({required this.message});
}

class QualificationAdded extends QualificationState {
  final DocQualification qualification;
  QualificationAdded({required this.qualification});
}

class QualificationDeleted extends QualificationState {
  final String id;
  QualificationDeleted({required this.id});
}

class QualificationUpdated extends QualificationState {
  final DocQualification qualification;
  QualificationUpdated({required this.qualification});
}

class QualificationAdding extends QualificationState {}

class QualificationDeleting extends QualificationState {}

class QualificationUpdating extends QualificationState {}

class QualificationAddingFailure extends QualificationState {
  final String message;
  QualificationAddingFailure({required this.message});
}

class QualificationDeletingFailure extends QualificationState {
  final String message;
  QualificationDeletingFailure({required this.message});
}

class QualificationUpdatingFailure extends QualificationState {
  final String message;
  QualificationUpdatingFailure({required this.message});
}

class TokenExpired extends QualificationState {}


