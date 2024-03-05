abstract class DocProfileEvent {}

class GetDocProfile extends DocProfileEvent {
  final String doctorId;
  GetDocProfile({required this.doctorId});
}

class GetDocQualification extends DocProfileEvent {
  final String doctorId;
  GetDocQualification({required this.doctorId});
}

class GetDocRatings extends DocProfileEvent {
  final String doctorId;
  GetDocRatings({required this.doctorId});
}

class ToggleFavourite extends DocProfileEvent {
  final String doctorId;
  ToggleFavourite({required this.doctorId});
}

class CreateChatRoom extends DocProfileEvent {
  final String doctorId;
  CreateChatRoom({required this.doctorId});
}