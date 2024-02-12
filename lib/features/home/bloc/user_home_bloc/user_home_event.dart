abstract class UserHomeEvent {}

class FetchUserHomeEvent extends UserHomeEvent {}

class ToggleFavouriteEvent extends UserHomeEvent {
  final String doctorId;

  ToggleFavouriteEvent({required this.doctorId});
}