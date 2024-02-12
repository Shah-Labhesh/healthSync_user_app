abstract class QualificationEvent {}

class GetQualifications extends QualificationEvent {}

class AddQualification extends QualificationEvent {
  Map<String, dynamic> body;

  AddQualification({
    required this.body,
  });
}

class DeleteQualification extends QualificationEvent {
  final String id;

  DeleteQualification({required this.id});
}

class UpdateQualification extends QualificationEvent {
  final String id;
  Map<String, dynamic> body;

  UpdateQualification({
    required this.id,
    required this.body,
  });
}
