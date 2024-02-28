abstract class RateExperienceEvent {}

class RateExperience extends RateExperienceEvent {
  final String id;
  final Map<String, dynamic> data;

  RateExperience({required this.id, required this.data});
}
